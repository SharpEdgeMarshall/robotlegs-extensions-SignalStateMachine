package robotlegs.bender.extensions.signalStateMachine
{
    import robotlegs.bender.extensions.signalStateMachine.api.IFSMController;
    import org.osflash.statemachine.core.IFSMInjector;
    import org.osflash.statemachine.core.ILoggable;
    import org.osflash.statemachine.core.IStateMachine;
    import robotlegs.bender.extensions.signalStateMachine.decoding.SignalXMLStateDecoder;
    import robotlegs.bender.extensions.signalStateMachine.transitioning.SignalTransitionController;
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import robotlegs.bender.framework.api.IInjector;
    import org.osflash.statemachine.FSMInjector;
    import org.osflash.statemachine.StateMachine;

    /**
     * A helper class that wraps the injection of the Signal StateMachine
     * to simplify creation.
     */
    public class SignalFSMInjector
    {

        /**
         * The IInjector into which the StateMachine elements will be injected
         */
        [Inject]
        public var injector:IInjector;

        /**
         * The ISignalCommandMap in which the commands will be mapped to each states' Signals
         */
        [Inject]
        public var signalCommandMap:ISignalCommandMap;

        /**
         * @private
         */
        private var _decoder:SignalXMLStateDecoder;

        /**
         * @private
         */
        private var _fsmInjector:IFSMInjector;

        /**
         * @private
         */
        private var _stateMachine:IStateMachine;

        /**
         * @private
         */
        private var _transitionController:SignalTransitionController;

        /**
         * Creates an instance of the injector
         */
        public function SignalFSMInjector()
        {
        }

        /**
         * Adds a commandClass to the decoder.
         *
         * Any Command declared in the StateDeclaration must be added before the StateMachine is injected
         * @param commandClass a command Class reference
         * @return Whether the command Class was added successfully
         */
        public function addClass(commandClass:Class):Boolean
        {
            return this._decoder.addClass(commandClass);
        }

        /**
         * The destroy method for GC.
         *
         * NB Once injected the instance is no longer needed, so it can be destroyed
         */
        public function destroy():void
        {
			this.injector = null;
			this.signalCommandMap = null;
			
			this._fsmInjector.destroy();
			this._fsmInjector = null;
			this._decoder = null;
			this._stateMachine = null;
			this._transitionController = null;
        }

        /**
         * Test to determine whether a particular class has already been added
         * to the decoder
         * @param name this can either be the name, the fully qualified name or an instance of the Class
         * @return
         */
        public function hasClass(name:Object):Boolean
        {
            return this._decoder.hasClass(name);
        }

        /**
         * Initiates the Injector
         * @param stateDefinition the StateMachine declaration
         */
        public function initiate(stateDefinition:XML, logger:ILoggable = null):void
        {
            // create a SignalStateDecoder and pass it the State Declaration
			this._decoder = new SignalXMLStateDecoder(stateDefinition, this.injector, this.signalCommandMap);
            // add it the FSMInjector
			this._fsmInjector = new FSMInjector(this._decoder);
            // create a transitionController
			this._transitionController = new SignalTransitionController(null, logger);
            // and pass it to the StateMachine
			this._stateMachine = new StateMachine(this._transitionController, logger);
        }

        /**
         * Injects the StateMachine
         */
        public function inject():void
        {

            // inject the statemachine (mainly to make sure that it doesn't get GCd )
			this.injector.map(IStateMachine).toValue(this._stateMachine);
            // inject the fsmController to allow actors to control fsm
            this.injector.map(IFSMController).toValue(this._transitionController.fsmController);

            // inject the statemachine, it will proceed to the initial state.
            // NB no injection rules have been set for view or model yet, the initial state
            // should be a resting one and the next state should be triggered by the
            // onApplicationComplete event in the ApplicationMediator
			this._fsmInjector.inject(this._stateMachine);
        }
    }
}