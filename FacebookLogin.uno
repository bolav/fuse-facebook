using Uno;
using Uno.Collections;
using Fuse;
using Uno.Compiler.ExportTargetInterop;

[TargetSpecificImplementation]
extern (iOS) public class FacebookLogin
{
	public FacebookLogin () {

	}

	public void ShowButton () {
		var uivc = iOS.UIKit.UIApplication._sharedApplication().KeyWindow.RootViewController;
		ViewImpl(uivc);
	}

	[TargetSpecificImplementation]
	extern(iOS)
	public void ViewImpl(iOS.UIKit.UIViewController controller);
}
