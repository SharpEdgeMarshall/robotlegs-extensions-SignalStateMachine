package robotlegs.bender.extensions.signalStateMachine.api
{

    public interface IPayload
    {

        function get body():Object;
        function get isNull():Boolean;
    }
}