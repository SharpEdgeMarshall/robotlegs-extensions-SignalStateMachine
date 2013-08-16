package robotlegs.bender.extensions.signalStateMachine.signals
{
    import org.osflash.signals.Signal;
    import robotlegs.bender.extensions.signalStateMachine.api.IPayload;

    public class ExitingGuard extends Signal
    {
        public function ExitingGuard()
        {
            super(IPayload);
        }
    }
}