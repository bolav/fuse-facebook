using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Controls;
using iOS.UIKit;
using Uno.Compiler.ExportTargetInterop;

[TargetSpecificImplementation]
extern (iOS)
public class FBSDKLoginButtonNativeView : Fuse.iOS.NativeViews.NativeView
{
	internal override UIView Create()
	{
		var v = CreateImpl();
		return v;
	}


	protected override float2 Size { get { var p = ParentNode as Panel; return p.ActualSize; } }

	[TargetSpecificImplementation]
	extern(iOS) iOS.UIKit.UIView CreateImpl();

}

extern (!iOS) public class FBSDKLoginButtonNativeView : Fuse.iOS.NativeViews.NativeView {}
