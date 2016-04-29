using Uno;
using Uno.Threading;
using Fuse;
using Fuse.Scripting;
using Bolav.ForeignHelpers;

public class FacebookJS : NativeModule
{
	public FacebookJS() {
		AddMember(new NativePromise<string, string>("login", Login, null));
		if defined(iOS)
			AddMember(new NativePromise<ObjC.Object, Fuse.Scripting.Object>("me", Me, ConvertDict));
	}

	Future<string> Login (object[] args) {
		return FBImpl.LoginImpl();
	}

	extern(iOS) Future<ObjC.Object> Me (object[] args) {
		return FBImpl.MeImpl();
	}

	extern(iOS) static Fuse.Scripting.Object ConvertDict(Context context, ObjC.Object result)
	{
		var dict = new JSDict(context);
		dict.FromiOS(result);
		return dict.GetScriptingObject();
	}


}
