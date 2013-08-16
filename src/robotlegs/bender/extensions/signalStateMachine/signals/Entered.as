package robotlegs.bender.extensions.signalStateMachine.signals
{
    import org.osflash.signals.Signal;
    import robotlegs.bender.extensions.signalStateMachine.api.IPayload;

    public class Entered extends Signal
    {
        public function Entered()
        {
            super(IPayload);
        }
    }
}