using Uno;
using Uno.Collections;
using Fuse;
using Uno.Compiler.ExportTargetInterop;
using iOS.Foundation;

[TargetSpecificImplementation]
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

	[Require("Source.Import","FBSDKCoreKit/FBSDKCoreKit.h")]
	[Require("Source.Import","FBSDKLoginKit/FBSDKLoginKit.h")]

	public static void Register(string s) {
		var uri = new NSURL();
		uri.initWithString(s);
		var src = new NSString();
		src.initWithString("com.apple.mobilesafari");
		var app = iOS.UIKit.UIApplication._sharedApplication();
		extern (app,uri,src)"[[FBSDKApplicationDelegate sharedInstance] application:$0->Handle() openURL:$1->Handle() sourceApplication:$2->Handle() annotation:nil];";
	}
}

[TargetSpecificImplementation]
public extern(Android) class Facebook
{
	static Facebook () {
		debug_log "Running on Android";
		init();
	}

	[Foreign(Language.Java)]
	extern(Android) static void init () 
	@{
		com.facebook.FacebookSdk.sdkInitialize(getApplicationContext());
	@}
}

public extern(!iOS && !Android) class Facebook {}