package robotlegs.bender.extensions.signalStateMachine.api
{
    import org.osflash.signals.ISlot;
    import org.osflash.statemachine.core.IState;
    import org.osflash.statemachine.core.ITransitionPhase;
    import robotlegs.bender.extensions.signalStateMachine.transitioning.TransitionPhase;

    /**
     * The inward-facing interface between the FSMController and the
     * SignalTransitionController
     */
    public interface IFSMControllerOwner
    {

        /**
         * Allows the SignalTransitionController to listen to framework action requests.
         * @param listener the method to handle the action request
         * @return the listener Function passed as the parameter
         */
        function addActionListener(listener:Function):ISlot;

        /**
         * Allows the SignalTransitionController to listen to framework cancel requests.
         * @param listener the method to handle the cancel request
         * @return the listener Function passed as the parameter
         */
        function addCancelListener(listener:Function):ISlot;

        /**
         * The destroy method for GC
         */
        function destroy():void;

        /**
         * Dispatches the general <strong>changed</strong> phase to all framework
         * listeners.
         * @param state the current state.
         */
        function dispatchChanged(stateName:String):void;

        /**
         *  allows the SignalTransitionController to access whether to dispatch
         *  to the changed phase signal
         */
        function get hasChangedListener():Boolean;


        /**
         * Sets the current state when the transition has been successful
         * @param state the state that is to be the current state
         */
        function setCurrentState(state:IState):void;

        /**
         * Sets whether the StateMachine is undergoing a transition cycle
         */
        function setIsTransition(value:Boolean):void;

        /**
         * Sets the referring action of the transition cycle
         * @see TransitionPhases
         */
        function setReferringAction(value:String):void;

        /**
         * Sets the current phase of the transition cycle
         * @see TransitionPhases
         */
        function setTransitionPhase(value:ITransitionPhase):void;
    }
}