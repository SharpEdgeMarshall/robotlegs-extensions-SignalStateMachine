package robotlegs.bender.extensions.signalStateMachine
{
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.UID;
	
	public class SignalFSMInjectorExtension implements IExtension
	{
		private const _uid:String = UID.create(SignalFSMInjectorExtension);
		
		public function extend(context:IContext):void
		{
			context.injector.map(SignalFSMInjector).asSingleton();
		}
		
		public function toString():String
		{
			return this._uid;
		}
	}
}