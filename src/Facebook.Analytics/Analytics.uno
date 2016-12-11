using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
namespace Facebook
{
	[ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
	public class Analytics: Behavior
	{
		static Analytics () {
			debug_log "Registering Analytics callback";
			Facebook.Core.Init();
			Fuse.Platform.Lifecycle.EnteringForeground += OnEnteringForeground;
		}

		static void OnEnteringForeground(Fuse.Platform.ApplicationState s) {
			debug_log "EnteringForeground";
			ActivateImpl();
		}

		[Foreign(Language.ObjC)]
		extern(iOS) 
		static void ActivateImpl () 
		@{
			[FBSDKAppEvents activateApp];
		@}

		[Foreign(Language.ObjC)]
		extern(iOS) 
		public static void LogEvent (string name) 
		@{
			[FBSDKAppEvents logEvent:name];
		@}



	}
}
