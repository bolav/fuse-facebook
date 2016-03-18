using Uno;
using Uno.Collections;
using Fuse;
using iOS.UIKit;
using Uno.Compiler.ExportTargetInterop;

[Require("Xcode.FrameworkDirectory", "@('libs/ios':Path)")]
[Require("Xcode.Framework", "@('libs/ios/FBSDKCoreKit.framework':Path)")]
[Require("Xcode.Framework", "@('libs/ios/FBSDKLoginKit.framework':Path)")]
[Require("Xcode.Framework", "@('libs/ios/FBSDKShareKit.framework':Path)")]
[Require("Source.Include", "FBSDKCoreKit/FBSDKCoreKit.h")]
[Require("Source.Include", "FBSDKLoginKit/FBSDKLoginKit.h")]
[TargetSpecificImplementation]
extern (iOS)
public class FBLoginButtonImpl : Fuse.iOS.Controls.Control<FBLoginButton>
{
	internal override UIView CreateInternal()
	{
		var id = CreateImpl();
		iOS.UIKit.UIView v = new iOS.UIKit.UIView(id);
		return v;
	}

	[Foreign(Language.ObjC)]
	extern(iOS) ObjC.ID CreateImpl()
	@{
		FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
		return loginButton;
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
