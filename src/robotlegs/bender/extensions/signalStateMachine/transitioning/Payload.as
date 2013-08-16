package robotlegs.bender.extensions.signalStateMachine.transitioning
{
    import robotlegs.bender.extensions.signalStateMachine.api.IPayload;

    public class Payload implements IPayload
    {
        private var _body:Object;

        public function Payload(body:Object)
        {
            this._body = body;
        }

        public function get body():Object
        {
            return this._body;
        }

        public function get isNull():Boolean
        {
            return (this._body == null);
        }
    }
}