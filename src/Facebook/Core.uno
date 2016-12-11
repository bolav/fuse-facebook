using Uno;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
namespace Facebook
{
    extern(!mobile)
	public class Core
	{
		static public void Init() { }
	}

	[Require("Cocoapods.Podfile.Target", "pod 'FBSDKCoreKit'")]
	[Require("Cocoapods.Podfile.Target", "pod 'FBSDKShareKit'")]
    extern(iOS)
    public class Core
    {
        static public void Init()
        {
        }
    }

	[Require("Android.ResStrings.Declaration", "<string name=\"facebook_app_id\">@(Project.Facebook.AppID)</string>")]
	[Require("AndroidManifest.ApplicationElement", "<meta-data android:name=\"com.facebook.sdk.ApplicationId\" android:value=\"@string/facebook_app_id\"/>")]
	[Require("AndroidManifest.ApplicationElement", "<activity android:name=\"com.facebook.FacebookActivity\"></activity>")]
	[Require("Gradle.Dependencies.Compile","com.facebook.android:facebook-android-sdk:[4,5)")]
	[Require("Gradle.Repository","mavenCentral()")]
	extern(Android)
    public class Core
    {
		[Foreign(Language.Java)]
		static public void Init()
		@{
		@}
	}
}
