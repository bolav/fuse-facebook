using Uno;
using Uno.Collections;
using Fuse;
using iOS.UIKit;
using Uno.Compiler.ExportTargetInterop;

[Require("Xcode.FrameworkDirectory", "@('libs/ios':Path)")]
[Require("Xcode.Framework", "@('libs/ios/FBSDKCoreKit.framework':Path)")]
[Require("Xcode.Framework", "@('libs/ios/FBSDKLoginKit.framework':Path)")]
[Require("Xcode.Framework", "@('libs/ios/FBSDKShareKit.framework':Path)")]
[ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
[ForeignInclude(Language.ObjC, "FBSDKLoginKit/FBSDKLoginKit.h")]
[TargetSpecificImplementation]
extern (iOS)
public class FBLoginButtonImpl : Fuse.iOS.Controls.Control<FBLoginButton>
{
	internal override UIView CreateInternal()
	{
		var v = CreateImpl();
		return v;
	}

	[Foreign(Language.ObjC)]
	extern(iOS) iOS.UIKit.UIView CreateImpl()
	@{
		FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
		return (@{iOS.UIKit.UIView})uObjC::Lifetime::GetUnoObject(loginButton, @{iOS.UIKit.UIView:TypeOf});
	@}

	protected override void Attach()
	{
		// CreateInternal();
	}

	protected override void Detach()
	{
	}

	public override float2 GetMarginSize( LayoutParams lp ) {
		return float2(55);
	}

}

extern (!iOS) public class FBLoginButtonImpl : Fuse.iOS.Controls.Control<FBLoginButton> {}
