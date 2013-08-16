package robotlegs.bender.extensions.signalStateMachine.api
{
    import org.osflash.signals.ISignal;
    import org.osflash.statemachine.core.IState;

    /**
     * The contract between the State and the framework.
     *
     * The five phases defined here use Signals
     */
    public interface ISignalState extends IState
    {

        /**
         * The ISignal handling the <strong>cancelled</strong> phase of the state.
         */
        function get cancelled():ISignal;
        /**
         * The ISignal handling the <strong>entered</strong> phase of this state.
         */
        function get entered():ISignal;

        /**
         * The ISignal handling the <strong>enteringGuard</strong> phase of the state.
         */
        function get enteringGuard():ISignal;

        /**
         * The ISignal handling the <strong>exitingGuard</strong> phase of the state.
         */
        function get exitingGuard():ISignal;

        function get hasCancelled():Boolean;

        function get hasEntered():Boolean;

        function get hasEnteringGuard():Boolean;

        function get hasExitingGuard():Boolean;

        function get hasTearDown():Boolean;

        /**
         * The ISignal handling the <strong>tearDown</strong> phase of the state.
         */
        function get tearDown():ISignal;
    }
}