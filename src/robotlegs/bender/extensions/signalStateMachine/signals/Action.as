package robotlegs.bender.extensions.signalStateMachine.signals
{
    import org.osflash.signals.Signal;
    import robotlegs.bender.extensions.signalStateMachine.api.IPayload;

    public class Action extends Signal
    {
        public function Action()
        {
            super(String, IPayload);
        }
    }
}