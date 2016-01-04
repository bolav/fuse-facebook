using Uno;
using Uno.Collections;
using Fuse;
using Uno.Compiler.ExportTargetInterop;
using iOS.Foundation;

[TargetSpecificImplementation]
public extern(iOS) class FBiOS
{
	static FBiOS () {
		debug_log "Registering callback";
		Uno.Platform2.Application.ReceivedURI += OnReceivedUri;
	}

	static void OnReceivedUri(object sender, string uri) {
		if (uri.Substring(0,2) == "fb")
			Register(uri);
		// debug_log uri;
	}

	public static void Register(string s) {
		var uri = new NSString();
		uri.initWithString(s);
		var src = new NSString();
		src.initWithString("com.apple.mobilesafari");
// sourceApplication	__NSCFString *	@"com.apple.mobilesafari"	0x00007fe5625934d0
/*
  return [[FBSDKApplicationDelegate sharedInstance] application:application
    openURL:url
    sourceApplication:sourceApplication
    annotation:annotation
  ];

*/
		var app = iOS.UIKit.UIApplication._sharedApplication();
		extern (app,uri,src)"[[FBSDKApplicationDelegate sharedInstance] application:$0->Handle() openURL:$1->Handle() sourceApplication:$2->Handle() annotation:nil];";
	}
}

public extern(!iOS) class FBiOS {}