using Uno;
using Uno.Threading;
using Fuse;
using Uno.Compiler.ExportTargetInterop;

[TargetSpecificImplementation]
[ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
[ForeignInclude(Language.ObjC, "FBSDKLoginKit/FBSDKLoginKit.h")]
public extern(iOS) class FBImpl
{
	static FBImpl () {
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

	public static Future<string> LoginImpl()
	{
		var p = new Promise<string>();
		var closure = new LoginClosure(p);
		closure.Login();
		return p;
	}

	public static Future<ObjC.Object> MeImpl()
	{
		var p = new Promise<ObjC.Object>();
		var closure = new GraphClosure(p);
		closure.Execute("me");
		return p;
	}

}

[TargetSpecificImplementation]
[ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
[ForeignInclude(Language.ObjC, "FBSDKLoginKit/FBSDKLoginKit.h")]
public extern(iOS) class GraphClosure {
	Promise<ObjC.Object> promise;
	public GraphClosure(Promise<ObjC.Object> p) {
		promise = p;
	}

	public void Resolve(ObjC.Object id) {
		promise.Resolve(id);
	}

	public void Reject(string s) {
		promise.Reject(new Exception(s));
	}

	// https://developers.facebook.com/docs/reference/ios/current/class/FBSDKLoginManager/
	[Foreign(Language.ObjC)]
	extern(iOS)
	public void Execute(string path)
	@{
		dispatch_async(dispatch_get_main_queue(), ^{
			[[[FBSDKGraphRequest alloc] initWithGraphPath:path parameters:\\\@{@"fields": @"picture.type(large), email, name, first_name"}]
		         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		             if (!error) {
		                 @{GraphClosure:Of(_this).Resolve(ObjC.Object):Call(result)};
		         	 }
		         	 else {
		         	 	@{GraphClosure:Of(_this).Reject(string):Call(@"error")};
		         	 }
		    }];
		});
	@}

}


[TargetSpecificImplementation]
[ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
[ForeignInclude(Language.ObjC, "FBSDKLoginKit/FBSDKLoginKit.h")]
public extern(iOS) class LoginClosure {
	Promise<string> promise;
	public LoginClosure(Promise<string> p) {
		promise = p;
	}

	public void Resolve(string s) {
		promise.Resolve(s);
	}

	public void Reject(string s) {
		promise.Reject(new Exception(s));
	}

	// https://developers.facebook.com/docs/reference/ios/current/class/FBSDKLoginManager/
	[Foreign(Language.ObjC)]
	extern(iOS)
	public void Login()
	@{
		dispatch_async(dispatch_get_main_queue(), ^{
			FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
			::id vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
			[login
			  logInWithReadPermissions: @[@"public_profile", @"email"]
			        fromViewController:nil
			                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
			  if (error) { 
			    NSLog(@"Process error");
			    @{LoginClosure:Of(_this).Reject(string):Call(@"Error")};
			  } else if (result.isCancelled) {
			    NSLog(@"Cancelled");
			    @{LoginClosure:Of(_this).Reject(string):Call(@"Cancelled")};
			  } else {
			    NSLog(@"Logged in");
			    FBSDKAccessToken *ca = [FBSDKAccessToken currentAccessToken];
			    @{LoginClosure:Of(_this).Resolve(string):Call([ca tokenString])};
			  }
			}];
		});

	@}

}
