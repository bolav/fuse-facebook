using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Controls.Native.iOS;
using Uno.Compiler.ExportTargetInterop;

[ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
[ForeignInclude(Language.ObjC, "FBSDKLoginKit/FBSDKLoginKit.h")]
[TargetSpecificImplementation]
extern (iOS)
public class FBLoginButtonImpl : LeafView
{
	public FBLoginButtonImpl() : base(Create()) { }

	[Foreign(Language.ObjC)]
	static ObjC.Object Create()
	@{
		FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
		loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
		return loginButton;
	@}
}

[Require("Gradle.Dependency.Compile", "com.facebook.android:facebook-android-sdk:4.+")]
[Require("Android.ResStrings.Declaration", "<string name=\"facebook_app_id\">@(Project.Facebook.AppID)</string>")]
[Require("AndroidManifest.ApplicationElement", "<meta-data android:name=\"com.facebook.sdk.ApplicationId\" android:value=\"@string/facebook_app_id\"/>")]
[ForeignInclude(Language.Java,
                "com.facebook.AccessToken",
                "com.facebook.CallbackManager",
                "com.facebook.FacebookCallback",
                "com.facebook.FacebookException",
                "com.facebook.FacebookSdk",
                "com.facebook.login.LoginManager",
                "com.facebook.login.LoginResult",
                "com.facebook.login.widget.LoginButton",
                "com.google.android.gms.tasks.OnCompleteListener",
                "com.google.android.gms.tasks.Task",
                "com.google.firebase.auth.AuthCredential",
                "com.google.firebase.auth.AuthResult",
                "com.google.firebase.auth.FacebookAuthProvider",
                "com.google.firebase.auth.FirebaseAuth",
                "com.google.firebase.auth.FirebaseUser",
                "android.os.Handler")]
extern(android)
public class FBLoginButtonImpl : LeafView
{
	public FBLoginButtonImpl() : base(Create()) { }

	[Foreign(Language.Java)]
	static Java.Object Create()
	@{
		LoginButton loginButton = new LoginButton(com.fuse.Activity.getRootActivity());
		loginButton.setReadPermissions("email", "public_profile");
		loginButton.registerCallback(
		    (CallbackManager)@{FacebookService.CallbackManager},
		    new FacebookCallback<LoginResult>() {
		        public void onSuccess(LoginResult loginResult) {
		            @{OnAuth(Java.Object):Call(loginResult.getAccessToken())};
		        }

		        public void onCancel() {
		            @{OnFailure(string):Call("Facebook Auth Stage Cancelled")};
		        }

		        public void onError(FacebookException error) {
		            String reason = "Facebook Auth Stage Errored (" + error.getClass().getName() + "):\n" + error.getMessage();
		            @{OnFailure(string):Call(reason)};
		        }
		    });
		return loginButton;
	@}
}
