using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
namespace Facebook
{
	[ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
	[ForeignInclude(Language.Java, "com.facebook.appevents.AppEventsLogger")]
	public class Analytics: Behavior
	{
		static Analytics () {
			Init();
		}

		static bool _inited = false;

		public static void Init() {
			if (_inited) return;
			debug_log "Registering Analytics callback";
			Facebook.Core.Init();
			Fuse.Platform.Lifecycle.EnteringForeground += OnEnteringForeground;
		}

		static void OnEnteringForeground(Fuse.Platform.ApplicationState s) {
			debug_log "EnteringForeground";
			if defined(mobile)
				ActivateImpl();
		}

		[Foreign(Language.ObjC)]
		extern(iOS) 
		static void ActivateImpl () 
		@{
			[FBSDKAppEvents activateApp];
		@}

		[Foreign(Language.Java)]
		extern(Android)
		static void ActivateImpl ()
		@{
			AppEventsLogger.activateApp(Activity.getRootActivity());
		@}

		[Foreign(Language.ObjC)]
		extern(iOS) 
		public static void LogEvent (string name)
		@{
			[FBSDKAppEvents logEvent:name];
		@}

		[Foreign(Language.ObjC)]
		extern(iOS)
		public static void LogEvent (string name, string[] keys, string[] vals, int arr_len)
		@{
			NSDictionary *p = [NSDictionary dictionaryWithObjects:[vals copyArray] forKeys:[keys copyArray]];
			[FBSDKAppEvents logEvent:name parameters:p];
		@}

		[Foreign(Language.ObjC)]
		extern(iOS)
		public static void LogEvent (string name, double vts)
		@{
			[FBSDKAppEvents logEvent:name valueToSum:vts];
		@}

		[Foreign(Language.ObjC)]
		extern(iOS)
		public static void LogEvent (string name, double vts, string[] keys, string[] vals, int arr_len)
		@{
			NSDictionary *p = [NSDictionary dictionaryWithObjects:[vals copyArray] forKeys:[keys copyArray]];
			[FBSDKAppEvents logEvent:name valueToSum:vts parameters:p];
		@}




	}
}
