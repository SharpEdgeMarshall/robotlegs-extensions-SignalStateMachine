package robotlegs.bender.extensions.signalStateMachine.transitioning
{
    import org.osflash.statemachine.core.ITransitionPhase;

    public class TransitionPhase implements ITransitionPhase
    {
        public static const CANCELLED:TransitionPhase = new TransitionPhase("cancelled", 32);

        public static const ENTERED:TransitionPhase = new TransitionPhase("entered", 8);

        public static const ENTERING_GUARD:TransitionPhase = new TransitionPhase("enteringGuard", 4);

        public static const EXITING_GUARD:TransitionPhase = new TransitionPhase("exitingGuard", 2);

        public static const GLOBAL_CHANGED:TransitionPhase = new TransitionPhase("globalChanged", 64);

        public static const NONE:TransitionPhase = new TransitionPhase("none", 1);

        public static const TEAR_DOWN:TransitionPhase = new TransitionPhase("tearDown", 16);

        private var _index:int;

        private var _name:String;

        public function TransitionPhase(name:String, index:int)
        {
            this._name = name;
            this._index = index;
        }

        public function equals(value:Object):Boolean
        {
            return (value === this) || (value == this.name) || (value == this.index);
        }

        public function get index():int
        {
            return this._index;
        }

        public function get name():String
        {
            return this._name;
        }
    }
}