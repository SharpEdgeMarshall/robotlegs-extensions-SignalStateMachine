package org.osflash.statemachine.integration.basic {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.osflash.statemachine.SignalFSMInjector;
import org.osflash.statemachine.core.IFSMController;
import org.osflash.statemachine.core.IFSMProperties;
import org.osflash.statemachine.core.IPayload;
import org.osflash.statemachine.core.ISignalState;
import org.osflash.statemachine.core.IStateProvider;
import org.robotlegs.adapters.SwiftSuspendersInjector;
import org.robotlegs.base.GuardedSignalCommandMap;
import org.robotlegs.core.IGuardedSignalCommandMap;
import org.robotlegs.core.IInjector;

public class CancelledTransitionsDoNotChangeCurrentState {

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
    public function cancelling_transition_from_currentState_exitingGuard__state_does_not_change():void {
        _currentState.exitingGuard.addOnce( cancelTransition );
        _fsmController.pushTransition( "transition/test" );
        _fsmController.transition();
        assertThat( _fsmProperties.currentStateName, equalTo( "state/starting" ) );
    }

     [Test]
    public function cancelling_transition_from_targetState_enteringGuard__state_does_not_change():void {
        _targetState.enteringGuard.addOnce( cancelTransition );
        _fsmController.pushTransition( "transition/test" );
         _fsmController.transition();
        assertThat( _fsmProperties.currentStateName, equalTo( "state/starting" ) );
    }

    private function cancelTransition( payload:IPayload ):void {
        _fsmController.cancelStateTransition( _reason );
    }

    private function initFSM():void {
        const fsmInjector:SignalFSMInjector = new SignalFSMInjector( _injector, _signalCommandMap );
        fsmInjector.initiate( FSM );
        fsmInjector.inject();
    }

    private function initProps():void {
        _stateModel = _injector.getInstance( IStateProvider );
        _fsmProperties = _injector.getInstance( IFSMProperties );
        _fsmController = _injector.getInstance( IFSMController );
        _currentState = _stateModel.getState( "state/starting" ) as ISignalState;
        _targetState = _stateModel.getState( "state/testing" ) as ISignalState;
        _payloadBody = "testing,testing,1,2,3";
        _reason = "reason/testing";
    }

    private function initRL():void {
        _injector = new SwiftSuspendersInjector();
        _injector.mapValue( IInjector, _injector );
        _signalCommandMap = new GuardedSignalCommandMap( _injector );
    }

    private function disposeProps():void {
        _injector = null;
        _signalCommandMap = null;
        _stateModel = null;
        _fsmProperties = null;
        _fsmController = null;
        _currentState = null;
        _targetState = null;
        _payloadBody = null;
        _reason = null;
    }


    private var _injector:IInjector;
    private var _signalCommandMap:IGuardedSignalCommandMap;
    private var _stateModel:IStateProvider;
    private var _fsmProperties:IFSMProperties;
    private var _fsmController:IFSMController;
    private var _currentState:ISignalState;
    private var _targetState:ISignalState;
    private var _payloadBody:Object;
    private var _reason:String;
    private const FSM:XML =
                  <fsm initial="state/starting">
                      <state name="state/starting">
                          <transition name="transition/test" target="state/testing"/>
                      </state>
                      <state name="state/testing">
                          <transition name="transition/end" target="state/ending"/>
                      </state>
                      <state name="state/ending">
                          <transition name="transition/start" target="state/starting"/>
                      </state>
                  </fsm>
    ;

}
}
