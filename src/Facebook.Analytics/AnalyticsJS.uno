using Uno;
using Uno.UX;
using Uno.Threading;
using Fuse;
using Fuse.Scripting;
using Uno.Compiler.ExportTargetInterop;

namespace Facebook {
	[UXGlobalModule]
	public class AnalyticsJS : NativeModule
	{
		static readonly AnalyticsJS _instance;

		// TODO: Event for logged in
		// TODO: Rewrite to newest
		public AnalyticsJS () {
			if(_instance != null) return;

			Resource.SetGlobalKey(_instance = this, "Facebook/Analytics");
			Facebook.Core.Init();
			Facebook.Analytics.Init();
			AddMember(new NativeFunction("logEvent", (NativeCallback)LogEvent));
		}

		static object LogEvent (Context c, object[] args)
		{
			var name = args[0].ToString();
			if (args.Length > 1) {
				if (args[1] is Fuse.Scripting.Object) {
					var p = (Fuse.Scripting.Object)args[1];
					var keys = p.Keys;
					string[] objs = new string[keys.Length];
					for (int i=0; i < keys.Length; i++) {
						objs[i] = p[keys[i]].ToString();
					}
					if defined(mobile) {
						Facebook.Analytics.LogEvent(name, keys, objs, keys.Length);
						return null;
					}
				}
				else {
					var vts = Marshal.ToDouble(args[1]);
					if (args.Length > 2) {
						var p = (Fuse.Scripting.Object)args[2];
						var keys = p.Keys;
						string[] objs = new string[keys.Length];
						for (int i=0; i < keys.Length; i++) {
							objs[i] = p[keys[i]].ToString();
						}
						if defined(mobile) {
							Facebook.Analytics.LogEvent(name, vts, keys, objs, keys.Length);
							return null;
						}
					}
					else {
						if defined(mobile) {
							Facebook.Analytics.LogEvent(name, vts);
							return null;
						}						
					}
				}
				debug_log args[1];
				debug_log args[1].GetType();
			}
			if defined(mobile) {
				Facebook.Analytics.LogEvent(name);
			}
			else {
				debug_log "Facebook.Analytics.LogEvent(" + name + ") only working on mobile device";
			}
			return null;
		}


	}
}
