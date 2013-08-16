package robotlegs.bender.extensions.signalStateMachine.signals
{
    import org.osflash.signals.Signal;
    import robotlegs.bender.extensions.signalStateMachine.api.IPayload;

    public class Cancelled extends Signal
    {
        public function Cancelled()
        {
            super(String, IPayload);
        }
    }
}