using Fuse.Controls.Native.iOS;
using Uno.Compiler.ExportTargetInterop;

[ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
[ForeignInclude(Language.ObjC, "FBSDKLoginKit/FBSDKLoginKit.h")]
[TargetSpecificImplementation]
extern (iOS)
public class FBLoginButtonImpl : LeafView
{
	public FBLoginButtonImpl(): base(Create()) {}

	[Foreign(Language.ObjC)]
	static ObjC.Object Create()
	@{
		FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
		return loginButton;
	@}

}

extern (!iOS) public class FBLoginButtonImpl : Fuse.Controls.Panel {
	
}
