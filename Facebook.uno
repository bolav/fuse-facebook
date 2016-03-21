using Uno;
using Uno.Collections;
using Fuse;
using Uno.Compiler.ExportTargetInterop;
using iOS.Foundation;

[TargetSpecificImplementation]
[ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
[ForeignInclude(Language.ObjC, "FBSDKLoginKit/FBSDKLoginKit.h")]
public extern(iOS) class Facebook
{
	static Facebook () {
		debug_log "Registering callback";
		Uno.Platform2.Application.ReceivedURI += OnReceivedUri;
	}

	static void OnReceivedUri(object sender, string uri) {
		if (uri.Substring(0,2) == "fb")
			Register(uri);
		// debug_log uri;
	}

	[Foreign(Language.ObjC)]
	extern(iOS)
	public static void Register(string s)
	@{
		NSURL *url = [[NSURL alloc] initWithString:s];
		NSString *src = @"com.apple.mobilesafari";
		[[FBSDKApplicationDelegate sharedInstance]
			application:[UIApplication sharedApplication]
			openURL:url
			sourceApplication:src
			annotation:nil];
	@}
}

[TargetSpecificImplementation]
public extern(Android) class Facebook
{
	static Facebook () {
		debug_log "Running on Android";
	}

	bool inited = false;
	public void Login () {
		debug_log "Try to login";
		if (!inited) {
			init(Android.android.app.Activity.GetAppActivity());
			inited = true;
		}
		LoginImpl(Android.android.app.Activity.GetAppActivity());
	}

	[Foreign(Language.Java)]
	extern(Android) void LoginImpl (Android.android.app.Activity ctx)
	@{
		com.facebook.CallbackManager callbackManager = com.facebook.CallbackManager.Factory.create();

		com.facebook.login.LoginManager.getInstance().registerCallback(callbackManager,
		        new com.facebook.FacebookCallback<com.facebook.login.LoginResult>() {
		            @Override
		            public void onSuccess(com.facebook.login.LoginResult loginResult) {
		                // App code
		                android.util.Log.d("@(Activity.Name)", "your message");
		            }

		            @Override
		            public void onCancel() {
		                 // App code
		                 android.util.Log.d("@(Activity.Name)", "your message");
		            }

		            @Override
		            public void onError(com.facebook.FacebookException exception) {
		                 // App code   
		                 android.util.Log.d("@(Activity.Name)", "your message");
		            }
		});
		com.facebook.login.LoginManager.getInstance().logInWithReadPermissions(ctx, java.util.Arrays.asList("public_profile", "user_friends"));

	@}

	[Require("Android.ResStrings.Declaration", "<string name=\"facebook_app_id\">app_id_here</string>")]
	[Require("AndroidManifest.ApplicationElement", "<meta-data android:name=\"com.facebook.sdk.ApplicationId\" android:value=\"@string/facebook_app_id\"/>")]
	[Require("AndroidManifest.ApplicationElement", "<activity android:name=\"com.facebook.FacebookActivity\"></activity>")]
	[Require("Gradle.Dependencies.Compile","com.facebook.android:facebook-android-sdk:[4,5)")]
	[Require("Gradle.Repository","mavenCentral()")]

	[Foreign(Language.Java)]
	extern(Android) static void init (Android.android.content.Context ctx) 
	@{
		debug_log("" + FacebookActivity.class);
		com.facebook.FacebookSdk.sdkInitialize(((android.content.Context)ctx));
	@}
}

public extern(!iOS && !Android) class Facebook {}