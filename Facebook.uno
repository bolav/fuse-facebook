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
		}
		LoginImpl();
	}

	[Foreign(Language.Java)]
	extern(Android) void LoginImpl ()
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
	@}

	[Foreign(Language.Java)]
	extern(Android) static void init (Android.android.content.Context ctx) 
	@{
		com.facebook.FacebookSdk.sdkInitialize(((android.content.Context)ctx));
	@}
}

public extern(!iOS && !Android) class Facebook {}