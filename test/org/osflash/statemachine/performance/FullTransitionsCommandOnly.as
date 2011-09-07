package org.osflash.statemachine.performance {

import org.hamcrest.assertThat;
import org.hamcrest.number.lessThan;
import org.osflash.statemachine.SignalFSMInjector;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.core.IStateProvider;
import org.osflash.statemachine.support.CommandA;
import org.osflash.statemachine.support.SampleCommandA;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

public class FullTransitionsCommandOnly {


    [Before]
    public function before():void {
        initRL();
        initFSM();
        initProps();
    }

    [After]
    public function after():void {
        disposeProps();
    }

    [Test]

    public function run():void {
        const startTime:Number = new Date().time;
        const iterations:int = 10000;
        var count:int = 0;

        while ( count < iterations ) {
            _fsmController.pushTransition( "transition/next" );
            _fsmController.transition();
            count++;
        }

        const duration:Number = new Date().time - startTime;
        const results:Number = ( duration / iterations );
        // this takes 0.11
        assertThat( results, lessThan( 0.2 ) );
    }

    private function initFSM():void {
        const fsmInjector:SignalFSMInjector = new SignalFSMInjector( _injector, _signalCommandMap );
        fsmInjector.initiate( FSM );
        fsmInjector.addClass(CommandA);
        fsmInjector.inject();
    }


    private function initProps():void {
        _fsmController = _injector.getInstance( IFSMController );
        _stateModel = _injector.getInstance( IStateProvider );
        _startingState = _stateModel.getState( "state/starting" ) as ISignalState;
        _endingState = _stateModel.getState( "state/ending" ) as ISignalState;
    }

    private function initRL():void {
        _injector = new SwiftSuspendersInjector();
        _injector.mapValue( IInjector, _injector );
        _signalCommandMap = new GuardedSignalCommandMap( _injector );
    }

    private function disposeProps():void {
        _injector = null;
        _signalCommandMap = null;
        _fsmController = null;
    }


    private var _injector:IInjector;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _fsmController:IFSMController;
    private var _stateModel:IStateProvider;
    private var _startingState:ISignalState;
    private var _endingState:ISignalState;
    private const FSM:XML =
                  <fsm initial="state/starting">
                      <state name="state/starting">
                          <enteringGuard>
                              <commandClass classPath="CommandA"/>
                          </enteringGuard>
                          <exitingGuard>
                              <commandClass classPath="CommandA"/>
                          </exitingGuard>
                          <tearDown>
                              <commandClass classPath="CommandA"/>
                          </tearDown>
                          <entered>
                              <commandClass classPath="CommandA"/>
                          </entered>
                          <transition name="transition/next" target="state/ending"/>
                      </state>
                      <state name="state/ending">
                          <enteringGuard>
                              <commandClass classPath="CommandA"/>
                          </enteringGuard>
                          <exitingGuard>
                              <commandClass classPath="CommandA"/>
                          </exitingGuard>
                          <tearDown>
                              <commandClass classPath="CommandA"/>
                          </tearDown>
                          <entered>
                              <commandClass classPath="CommandA"/>
                          </entered>
                          <transition name="transition/next" target="state/starting"/>
                      </state>
                  </fsm>
    ;

}
}
