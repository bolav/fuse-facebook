using Uno;
using Uno.Threading;
using Fuse;
using Fuse.Scripting;
using Bolav.ForeignHelpers;
using Uno.Compiler.ExportTargetInterop;

public class FacebookJS : NativeModule
{
	public FacebookJS() {
		AddMember(new NativePromise<string, string>("login", Login, null));
		if defined(iOS)
			AddMember(new NativePromise<ObjC.Object, Fuse.Scripting.Object>("me", Me, ConvertDict));
		if defined(Android)
			AddMember(new NativePromise<Java.Object, Fuse.Scripting.Object>("me", Me, ConvertJavaJson));
	}

	Future<string> Login (object[] args) {
		return FBImpl.LoginImpl();
	}

	extern(iOS) Future<ObjC.Object> Me (object[] args) {
		return FBImpl.MeImpl();
	}

	extern(Android) Future<Java.Object> Me (object[] args) {
		return FBImpl.MeImpl();
	}

	extern(iOS) static Fuse.Scripting.Object ConvertDict(Context context, ObjC.Object result)
	{
		var dict = new JSDict(context);
		dict.FromiOS(result);
		return dict.GetScriptingObject();
	}

	extern(Android) static Fuse.Scripting.Object ConvertJavaJson(Context context, Java.Object result)
	{
		var dict = new JSDict(context);
		ConvertJsonImpl(dict, result);
		return dict.GetScriptingObject();
	}

	[Foreign(Language.Java)]
	extern(Android) static void ConvertJsonImpl (JSDict dict, Java.Object jsonobj)
	@{
		org.json.JSONObject json = (org.json.JSONObject)jsonobj;
		for(java.util.Iterator<String> iter = json.keys();iter.hasNext();) {
		    String key = iter.next();
		    try {
		    	Object value = json.get(key);
		    	debug_log("value " + value.getClass().getName());
		    	@{JSDict:Of(dict).SetKeyVal(string, string):Call(key, json.getString(key))};
		    } catch (org.json.JSONException e) {
		    	debug_log("exception: " + e);
		    }
		}
	@}



}
