using Uno;
using Uno.Threading;

public extern(!iOS && !Android) class FBImpl
{
	public static Future<string> LoginImpl () {
		var p = new Promise<string>();
		p.Reject(new Exception("Not implemented for platform"));
		return p;
	}	
}
