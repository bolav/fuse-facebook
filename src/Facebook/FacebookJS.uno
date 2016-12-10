using Uno;
using Uno.Threading;
using Fuse;
using Fuse.Scripting;
using Uno.Compiler.ExportTargetInterop;

public class FacebookJS : NativeModule
{
	public FacebookJS() {
		AddMember(new NativePromise<string, string>("login", Login, null));
		if defined(iOS)
			AddMember(new NativePromise<ObjC.Object, string>("me", Me, ConvertDict));
		if defined(Android)
			AddMember(new NativePromise<Java.Object, string>("me", Me, ConvertJavaJson));
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

	extern(iOS) static string ConvertDict(Context context, ObjC.Object result)
	{
		return ConvertDictToJson(result);
	}

	extern(Android) static string ConvertJavaJson(Context context, Java.Object result)
	{
		return ConvertJsonImpl(result);
	}

	[Foreign(Language.ObjC)]
	extern(iOS) static string ConvertDictToJson (ObjC.Object dict)
	@{
		NSError *error;
		NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
		                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
		                                                     error:&error];

		if (! jsonData) {
		    NSLog(@"Got an error: %@", error);
		    return nil;
		} else {
		    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		    return jsonString;
		}
	@}

	[Foreign(Language.Java)]
	extern(Android) static string ConvertJsonImpl (Java.Object jsonobj)
	@{
		org.json.JSONObject json = (org.json.JSONObject)jsonobj;
		return json.toString();
	@}



}
