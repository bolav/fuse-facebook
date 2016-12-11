using Uno;
using Uno.Threading;
using Fuse;
using Uno.Compiler.ExportTargetInterop;

[ForeignInclude(Language.Java,
                "android.app.Activity")]
[TargetSpecificImplementation]
public extern(Android) class FBImpl
{
	public static string token;
	static Java.Object myCallbackManager;
	static Java.Object _intentListener;
	static bool inited = false;

	public static Future<string> LoginImpl () {
		if (!inited) {
			_intentListener = Init();
			myCallbackManager = GetCallbackManager();
			inited = true;
		}
		var p = new Promise<string>();
		var closure = new LoginClosure(p, myCallbackManager);
		closure.Login();
		return p;
	}

	public static Future<Java.Object> MeImpl()
	{
		var p = new Promise<Java.Object>();
		var closure = new GraphMeClosure(p);
		closure.Execute(token);
		return p;
	}

	[Foreign(Language.Java)]
	extern(Android) static Java.Object Init ()
	@{
		Activity a = com.fuse.Activity.getRootActivity();
		com.facebook.FacebookSdk.sdkInitialize(((android.content.Context)a));

		com.fuse.Activity.ResultListener l = new com.fuse.Activity.ResultListener() {
		    @Override public boolean onResult(int requestCode, int resultCode, android.content.Intent data) {
		        return @{OnRecieved(int,int,Java.Object):Call(requestCode, resultCode, data)};
		    }
		};
		com.fuse.Activity.subscribeToResults(l);
		return l;
	@}

	[Foreign(Language.Java)]
	static extern(Android) bool OnRecieved(int requestCode, int resultCode, Java.Object data)
	@{
		android.content.Intent i = (android.content.Intent)data;
		com.facebook.CallbackManager callbackManager = (com.facebook.CallbackManager)@{myCallbackManager:Get()};
		return callbackManager.onActivityResult(requestCode, resultCode, i);
	@}

	[Foreign(Language.Java)]
	extern(Android) static Java.Object GetCallbackManager()
	@{
		return com.facebook.CallbackManager.Factory.create();
	@}

}

[ForeignInclude(Language.Java,
	            "com.facebook.AccessToken",
	            "com.facebook.GraphRequest",
	            "com.facebook.GraphResponse",
	            "org.json.JSONObject",
	            "android.os.Bundle")]
public extern(Android) class GraphMeClosure {
	Promise<Java.Object> promise;
	public GraphMeClosure(Promise<Java.Object> p) {
		promise = p;
	}

	public void Resolve(Java.Object id) {
		promise.Resolve(id);
	}

	public void Reject(string s) {
		promise.Reject(new Exception(s));
	}

	[Foreign(Language.Java)]
	extern(Android)
	public void Execute(string token)
	@{
		GraphRequest request = GraphRequest.newMeRequest(
		        AccessToken.getCurrentAccessToken(),
		        new GraphRequest.GraphJSONObjectCallback() {
		            @Override
		            public void onCompleted(
		                   JSONObject object,
		                   GraphResponse response) {
		            	@{GraphMeClosure:Of(_this).Resolve(Java.Object):Call(object)};
		            	// Resolve(object);
		                // Application code
		            }
		        });
		Bundle parameters = new Bundle();
		parameters.putString("fields", "picture.type(large), email, name, first_name");
		request.setParameters(parameters);
		request.executeAsync();
	@}

}

[ForeignInclude(Language.Java,
                "android.app.Activity")]
public extern(Android) class LoginClosure {
	Promise<string> promise;
	static Java.Object myCallbackManager;

	public LoginClosure(Promise<string> p, Java.Object cbm) {
		promise = p;
		myCallbackManager = cbm;
	}

	public void Resolve(string s) {
		promise.Resolve(s);
		FBImpl.token = s;
	}

	public void Reject(string s) {
		promise.Reject(new Exception(s));
	}

	[Foreign(Language.Java)]
	public extern(Android) void Login ()
	@{
		Activity a = com.fuse.Activity.getRootActivity();
		com.facebook.CallbackManager callbackManager = (com.facebook.CallbackManager)@{myCallbackManager:Get()};
		com.facebook.login.LoginManager.getInstance().registerCallback(callbackManager,
		        new com.facebook.FacebookCallback<com.facebook.login.LoginResult>() {
		            @Override
		            public void onSuccess(com.facebook.login.LoginResult loginResult) {
		            	@{LoginClosure:Of(_this).Resolve(string):Call("Success")};
		            }

		            @Override
		            public void onCancel() {
		            	@{LoginClosure:Of(_this).Reject(string):Call("Canceled")};
		            }

		            @Override
		            public void onError(com.facebook.FacebookException exception) {
					    @{LoginClosure:Of(_this).Reject(string):Call(String.format("Error: %s", exception.toString()))};
		            }
		});
		com.facebook.login.LoginManager.getInstance().logInWithReadPermissions(a, java.util.Arrays.asList("public_profile", "email"));

	@}

}
