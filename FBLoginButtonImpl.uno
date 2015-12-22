using Uno;
using Uno.Collections;
using Fuse;
using iOS.UIKit;
using Uno.Compiler.ExportTargetInterop;

[TargetSpecificImplementation]
extern (iOS)
public class FBLoginButtonImpl : Fuse.iOS.Controls.Control<FBLoginButton>
{
	internal override UIView CreateInternal()
	{
		var v = CreateImpl();
		return v;
	}

	[TargetSpecificImplementation]
	extern(iOS) iOS.UIKit.UIView CreateImpl();

	protected override void Attach()
	{
		// CreateInternal();
	}

	protected override void Detach()
	{
	}

	public override float2 GetMarginSize( float2 fillSize, Fuse.SizeFlags fillSet ) {
		return float2(55);
	}

}

extern (!iOS) public class FBLoginButtonImpl : Fuse.iOS.Controls.Control<FBLoginButton> {}
