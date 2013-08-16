package robotlegs.bender.extensions.signalStateMachine.base
{
    import org.osflash.signals.ISlot;
    import org.osflash.signals.Signal;
    import org.osflash.statemachine.core.IState;
    import org.osflash.statemachine.core.ITransitionPhase;
    import org.osflash.statemachine.errors.StateTransitionError;
    import robotlegs.bender.extensions.signalStateMachine.api.IFSMController;
    import robotlegs.bender.extensions.signalStateMachine.api.IFSMControllerOwner;
    import robotlegs.bender.extensions.signalStateMachine.api.IPayload;
    import robotlegs.bender.extensions.signalStateMachine.signals.Action;
    import robotlegs.bender.extensions.signalStateMachine.signals.Cancel;
    import robotlegs.bender.extensions.signalStateMachine.signals.Changed;
    import robotlegs.bender.extensions.signalStateMachine.transitioning.Payload;
    import robotlegs.bender.extensions.signalStateMachine.transitioning.TransitionPhase;

    /**
     * SignalStateMachine FSMController composes the Signals that communicate between the StateMachine
     * and the framework actors.  It should be injected its IFSMController interface.
     */
    public class FSMController implements IFSMController, IFSMControllerOwner
    {

        /**
         * @private
         */
        protected var _action:Signal;

        /**
         * @private
         */
        protected var _cancel:Signal;

        /**
         * @private
         */
        protected var _changed:Signal;

        /**
         * @private
         */
        private const ILLEGAL_ACTION_ERROR:String = "An new transition can not be actioned from an enteringGuard, exitingGuard or a tearDown phase";

        /**
         * @private
         */
        private const ILLEGAL_CANCEL_ERROR:String = "A transition can only be cancelled from an enteringGuard or exitingGuard phase";

        /**
         * @private
         */
        private var _cacheActionName:String;

        /**
         * @private
         */
        private var _cachePayload:IPayload;

        /**
         * @private
         */
        private var _currentStateName:String;

        /**
         * @private
         */
        private var _isTransitioning:Boolean;

        /**
         * @private
         */
        private var _referringAction:String;

        /**
         * @private
         */
        private var _transitionPhase:ITransitionPhase = TransitionPhase.NONE;

        /**
         * Creates a new instance of FSMController
         */
        public function FSMController()
        {
            this._action = new Action();
            this._cancel = new Cancel();
            this._changed = new Changed();
        }

        /**
         * Sends an action to the StateMachine, precipitating a state transition.
         *
         * If a transition is actioned during a permitted transition phase, then the action is scheduled to be sent
         * immediately the transition cycle is over.
         *
         * @param actionName the name of the action.
         * @param payload the data to be sent with the action.
         *
         * @throws org.osflash.statemachine.errors.StateTransitionError Thrown if a transition is actioned from a
         * <strong>tearDown</strong>, <strong>enteringGuard</strong> or <strong>enteringGuard</strong> phase of a
         * transition cycle.
         */
        public function action(actionName:String, payload:Object = null):void
        {

            var isIllegal:Boolean =
                (this._transitionPhase == TransitionPhase.TEAR_DOWN ||
                this._transitionPhase == TransitionPhase.ENTERING_GUARD ||
                this._transitionPhase == TransitionPhase.EXITING_GUARD);

            if (isIllegal)
            {
                throw new StateTransitionError(ILLEGAL_ACTION_ERROR);
            }
            else
            {
                this.instigateAction(actionName, payload);
            }

        }

        /**
         * @inheritDoc
         */
        public function addActionListener(listener:Function):ISlot
        {
            return this._action.add(listener);
        }

        /**
         * @inheritDoc
         */
        public function addCancelListener(listener:Function):ISlot
        {
            return this._cancel.add(listener);
        }

        /**
         * @inheritDoc
         */
        public function addChangedListener(listener:Function):ISlot
        {
            return this._changed.add(listener);
        }

        /**
         * @inheritDoc
         */
        public function addChangedListenerOnce(listener:Function):ISlot
        {
            return this._changed.addOnce(listener);
        }

        /**
         * Cancels the current transition.
         *
         * NB: A transitions can only be cancelled during the <strong>enteringGuard</strong> or <strong>exitingGuard</strong>
         * phases of a transition.
         *
         * @param reason information regarding the reason for the cancellation
         * @param payload the data to be sent to the <strong>cancelled</strong> phase.
         * @throws org.osflash.statemachine.errors.StateTransitionError Thrown if a transition is cancelled from a transition phase
         * other than an enteringGuard or exitingGuard.
         */
        public function cancel(reason:String, payloadBody:Object = null):void
        {

            var payload:IPayload = wrapPayload(payloadBody);

            var isLegal:Boolean =
                (this._transitionPhase == TransitionPhase.ENTERING_GUARD ||
                this._transitionPhase == TransitionPhase.EXITING_GUARD);

            if (isLegal)
            {
                this._cancel.dispatch(reason, payload);
            }
            else
            {
                throw new StateTransitionError(ILLEGAL_CANCEL_ERROR);
            }

        }

        /**
         * @inheritDoc
         */
        public function get currentStateName():String
        {
            return this._currentStateName;
        }

        /**
         * @inheritDoc
         */
        public function destroy():void
        {
			this._action.removeAll();
			this._cancel.removeAll();
			this._changed.removeAll();
			this._action = null;
			this._cancel = null;
			this._changed = null;
        }

        /**
         * @inheritDoc
         */
        public function dispatchChanged(stateName:String):void
        {
			this._changed.dispatch(stateName);
        }

        /**
         * @inheritDoc
         */
        public function get hasChangedListener():Boolean
        {
            return (this._changed == null) ? false : (this._changed.numListeners > 0);
        }

        /**
         * @inheritDoc
         */
        public function get isTransitioning():Boolean
        {
            return this._isTransitioning;
        }

        /**
         * @inheritDoc
         */
        public function get referringAction():String
        {
            return this._referringAction;
        }

        /**
         * @inheritDoc
         */
        public function removeChangedListener(listener:Function):ISlot
        {
            return this._changed.remove(listener);
        }

        /**
         * @inheritDoc
         */
        public function setCurrentState(state:IState):void
        {
			this._currentStateName = state.name;
        }

        /**
         * @inheritDoc
         */
        public function setIsTransition(value:Boolean):void
        {
			this._isTransitioning = value;
        }


        /**
         * @inheritDoc
         */
        public function setReferringAction(value:String):void
        {
			this._referringAction = value;
        }

        /**
         * @inheritDoc
         */
        public function setTransitionPhase(value:ITransitionPhase):void
        {
			this._transitionPhase = value;
        }

        /**
         * @inheritDoc
         */
        public function get transitionPhase():String
        {
            return this._transitionPhase.name;
        }

        /**
         * @private
         */
        private function dispatchActionLater(stateName:String = null):void
        {
			this._action.dispatch(_cacheActionName, _cachePayload);
			this._cacheActionName = null;
			this._cachePayload = null;
        }

        /**
         * @private
         */
        private function instigateAction(actionName:String, payloadBody:Object = null):void
        {
            var payload:IPayload = this.wrapPayload(payloadBody);
            if (this.isTransitioning)
            {
				this._cacheActionName = actionName;
				this._cachePayload = payload;
				this.addChangedListenerOnce(dispatchActionLater);
            }
            else
            {
				this._action.dispatch(actionName, payload);
            }
        }

        private function wrapPayload(body:Object):IPayload
        {
            if (body is IPayload)
            {
                return IPayload(body);
            }
            else
            {
                return new Payload(body);
            }
        }
    }
}