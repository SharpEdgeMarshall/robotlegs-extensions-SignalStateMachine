package robotlegs.bender.extensions.signalStateMachine.signals
{
    import org.osflash.signals.Signal;

    public class Changed extends Signal
    {
        public function Changed()
        {
            super(String);
        }
    }
}