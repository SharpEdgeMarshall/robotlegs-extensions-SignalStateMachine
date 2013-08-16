package robotlegs.bender.extensions.signalStateMachine.transitioning
{
    import org.osflash.statemachine.base.BaseTransitionController;
    import org.osflash.statemachine.core.ILoggable;
    import org.osflash.statemachine.core.IState;
    import robotlegs.bender.extensions.signalStateMachine.api.IFSMController;
    import robotlegs.bender.extensions.signalStateMachine.api.IFSMControllerOwner;
    import robotlegs.bender.extensions.signalStateMachine.base.*;
    import robotlegs.bender.extensions.signalStateMachine.states.SignalState;

    /**
     * Encapsulates the state transition and thus the communications between
     * FSM and framework actors using Signals.
     */
    public class SignalTransitionController extends BaseTransitionController
    {

        /**
         * @private
         */
        private var _controller:IFSMControllerOwner;

        /**
         * Creates an instance of the SignalTransitionController
         * @param controller the object that acts as comms-bus
         * between the SignalTransitionController and the framework actors.
         */
        public function SignalTransitionController(controller:IFSMControllerOwner = null, logger:ILoggable = null)
        {
            super(logger);
            this._controller = controller || new FSMController();
			this._controller.addActionListener(handleAction);
			this._controller.addCancelListener(handleCancel);
        }

        /**
         * @inheritDoc
         */
        override public function destroy():void
        {
			this._controller.destroy();
            super.destroy();
        }

        /**
         * the IFSMController used.
         */
        public function get fsmController():IFSMController
        {
            return IFSMController(this._controller);
        }

        /**
         * @inheritDoc
         */
        protected function get currentSignalState():SignalState
        {
            return SignalState(this.currentState);
        }

        /**
         * @inheritDoc
         */
        override protected function dispatchCancelled():void
        {
            if (this.currentState != null && this.currentSignalState.hasCancelled)
            {
				this._controller.setTransitionPhase(TransitionPhase.CANCELLED);
				this.logPhase(TransitionPhase.CANCELLED, currentState.name);
				this.currentSignalState.dispatchCancelled(cancellationReason, cachedPayload);
            }
			this._controller.setTransitionPhase(TransitionPhase.NONE);
        }

        /**
         * @inheritDoc
         */
        override protected function dispatchGeneralStateChanged():void
        {
            // Notify the app generally th  at the state changed and what the new state is
            if (this._controller.hasChangedListener)
            {
				this._controller.setTransitionPhase(TransitionPhase.GLOBAL_CHANGED);
				this.logPhase(TransitionPhase.GLOBAL_CHANGED);
				this._controller.dispatchChanged(this.currentState.name);
            }
			this._controller.setTransitionPhase(TransitionPhase.NONE);
        }

        /**
         * @inheritDoc
         */
        override protected function onTransition(target:IState, payload:Object):void
        {

            var targetState:SignalState = SignalState(target);

            setReferringAction();

            // Exit the current State
            if (this.currentState != null && this.currentSignalState.hasExitingGuard)
            {
				this._controller.setTransitionPhase(TransitionPhase.EXITING_GUARD);
				this.logPhase(TransitionPhase.EXITING_GUARD, currentState.name);
				this.currentSignalState.dispatchExitingGuard(payload);
            }


            // Check to see whether the exiting guard has been canceled
            if (this.isCanceled)
            {
                return;
            }

            // Enter the next State
            if (targetState.hasEnteringGuard)
            {
				this._controller.setTransitionPhase(TransitionPhase.ENTERING_GUARD);
				this.logPhase(TransitionPhase.ENTERING_GUARD, targetState.name);
                targetState.dispatchEnteringGuard(payload);
            }

            // Check to see whether the entering guard has been canceled
            if (this.isCanceled)
            {
                return;
            }

            // teardown current state
            if (this.currentState != null && this.currentSignalState.hasTearDown)
            {
				this._controller.setTransitionPhase(TransitionPhase.TEAR_DOWN);
				this.logPhase(TransitionPhase.TEAR_DOWN, currentState.name);
				this.currentSignalState.dispatchTearDown();
            }

            setCurrentState(targetState);
            log("CURRENT STATE CHANGED TO: " + currentState.name);

            // Send the notification configured to be sent when this specific state becomes current
            if (this.currentSignalState.hasEntered)
            {
				this._controller.setTransitionPhase(TransitionPhase.ENTERED);
				this.logPhase(TransitionPhase.ENTERED, currentState.name);
				this.currentSignalState.dispatchEntered(payload);
            }

        }

        /**
         * @inheritDoc
         */
        override protected function setCurrentState(state:IState):void
        {
            super.setCurrentState(state);
			this._controller.setCurrentState(state);
        }

        override protected function setIsTransitioning(value:Boolean):void
        {
            super.setIsTransitioning(value);
			this._controller.setIsTransition(value);
        }

        private function setReferringAction():void
        {
            if (currentState == null)
            {
                return;
            }
			this._controller.setReferringAction(currentState.referringAction);
        }
    }
}