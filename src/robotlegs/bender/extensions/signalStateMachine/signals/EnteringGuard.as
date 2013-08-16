package robotlegs.bender.extensions.signalStateMachine.signals
{
    import org.osflash.signals.Signal;
    import robotlegs.bender.extensions.signalStateMachine.api.IPayload;

    public class EnteringGuard extends Signal
    {
        public function EnteringGuard()
        {
            super(IPayload);
        }
    }
}
