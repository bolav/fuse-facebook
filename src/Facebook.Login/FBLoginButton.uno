using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;

public class FBLoginButton : Panel
{
	protected override IView CreateNativeView()
	{
		if defined(mobile)
			return new FBLoginButtonImpl();
		else
			return base.CreateNativeView();
	}
}
