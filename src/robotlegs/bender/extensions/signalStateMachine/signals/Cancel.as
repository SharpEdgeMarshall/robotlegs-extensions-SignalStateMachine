package robotlegs.bender.extensions.signalStateMachine.signals
{
    import org.osflash.signals.Signal;
    import robotlegs.bender.extensions.signalStateMachine.api.IPayload;

    public class Cancel extends Signal
    {
        public function Cancel()
        {
            super(String, IPayload);
        }
    }
}