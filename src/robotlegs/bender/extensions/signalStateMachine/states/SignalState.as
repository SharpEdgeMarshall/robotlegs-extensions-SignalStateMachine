/*
 ADAPTED FOR ROBOTLEGS FROM:
 PureMVC AS3 Utility - StateMachine
 Copyright (c) 2008 Neil Manuell, Cliff Hall
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package robotlegs.bender.extensions.signalStateMachine.states
{
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    import org.osflash.statemachine.base.BaseState;
    import robotlegs.bender.extensions.signalStateMachine.api.ISignalState;
    import robotlegs.bender.extensions.signalStateMachine.signals.Cancelled;
    import robotlegs.bender.extensions.signalStateMachine.signals.Entered;
    import robotlegs.bender.extensions.signalStateMachine.signals.EnteringGuard;
    import robotlegs.bender.extensions.signalStateMachine.signals.ExitingGuard;
    import robotlegs.bender.extensions.signalStateMachine.signals.TearDown;
    import robotlegs.bender.framework.api.IInjector;

    /**
     * A SignalState defines five transition phases as Signals.
     */
    public class SignalState extends BaseState implements ISignalState
    {

        /**
         * @private
         */
        protected var _cancelled:Signal;

        /**
         * @private
         */
        protected var _entered:Signal;

        /**
         * @private
         */
        protected var _enteringGuard:Signal;

        /**
         * @private
         */
        protected var _exitingGuard:Signal;

        /**
         * @private
         */
        protected var _tearDown:Signal;

        /**
         * Creates an instance of a SignalState.
         *
         * @param name the id of the state
         */
        public function SignalState(
            name:String,
            entered:Signal = null,
            enteringGuard:Signal = null,
            exitingGuard:Signal = null,
            tearDown:Signal = null,
            cancelled:Signal = null):void
        {
            super(name);
            this._entered = entered;
            this._enteringGuard = enteringGuard;
            this._exitingGuard = exitingGuard;
            this._tearDown = tearDown;
            this._cancelled = cancelled;
        }

        /**
         * @inheritDoc
         */
        public function get cancelled():ISignal
        {
            return this._cancelled;
        }

        /**
         * The destroy method for gc
         */
        override public function destroy():void
        {

            if (this._entered != null)
            {
                this._entered.removeAll();
            }
            if (this._enteringGuard != null)
            {
                this._enteringGuard.removeAll();
            }
            if (this._exitingGuard != null)
            {
                this._exitingGuard.removeAll();
            }
            if (this._tearDown != null)
            {
                this._tearDown.removeAll();
            }
            if (this._cancelled != null)
            {
                this._cancelled.removeAll();
            }

            this._entered = null;
            this._enteringGuard = null;
            this._exitingGuard = null;
            this._tearDown = null;
            this._cancelled = null;

            super.destroy();
        }

        /**
         * Called by the SignalTransitionController to dispatch all <strong>cancelled</strong>
         * phase listeners.
         * @param reason the reason given for the cancellation
         * @param payload the data broadcast with the transition phase.
         */
        public function dispatchCancelled(reason:String, payload:Object):void
        {
            if (this._cancelled == null || this._cancelled.numListeners < 0)
            {
                return;
            }
            this._cancelled.dispatch(reason, payload);
        }

        /**
         * Called by the SignalTransitionController to dispatch all <strong>entered</strong>
         * phase listeners.
         * @param payload the data broadcast with the transition phase.
         */
        public function dispatchEntered(payload:Object):void
        {
            if (this._entered == null || this._entered.numListeners < 0)
            {
                return;
            }
            this._entered.dispatch(payload);
        }

        /**
         * Called by the SignalTransitionController to dispatch all <strong>enteringGuard</strong>
         * phase listeners.
         * @param payload the data broadcast with the transition phase.
         */
        public function dispatchEnteringGuard(payload:Object):void
        {
            if (this._enteringGuard == null || this._enteringGuard.numListeners < 0)
            {
                return;
            }
            this._enteringGuard.dispatch(payload);
        }

        /**
         * Called by the SignalTransitionController to dispatch all <strong>exitingGuard</strong>
         * phase listeners.
         * @param payload the data broadcast with the transition phase.
         */
        public function dispatchExitingGuard(payload:Object):void
        {
            if (this._exitingGuard == null || this._exitingGuard.numListeners < 0)
            {
                return;
            }
            this._exitingGuard.dispatch(payload);
        }

        /**
         * Called by the SignalTransitionController to dispatch all <strong>tearDown</strong>
         * phase listeners.
         */
        public function dispatchTearDown():void
        {
            if (this._tearDown == null || this._tearDown.numListeners < 0)
            {
                return;
            }
            this._tearDown.dispatch();
        }

        /**
         * @inheritDoc
         */
        public function get entered():ISignal
        {
            return this._entered;
        }

        /**
         * @inheritDoc
         */
        public function get enteringGuard():ISignal
        {
            return this._enteringGuard
        }

        /**
         * @inheritDoc
         */
        public function get exitingGuard():ISignal
        {
            return this._exitingGuard;
        }

        public function get hasCancelled():Boolean
        {
            return (this._cancelled != null);
        }

        public function get hasEntered():Boolean
        {
            return (this._entered != null);
        }

        public function get hasEnteringGuard():Boolean
        {
            return (this._enteringGuard != null);
        }

        public function get hasExitingGuard():Boolean
        {
            return (this._exitingGuard != null);
        }

        public function get hasTearDown():Boolean
        {
            return (this._tearDown != null);
        }

        /**
         * @inheritDoc
         */
        public function get tearDown():ISignal
        {
            return this._tearDown;
        }
    }
}