using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Controls;
using Fuse.Triggers.Actions;

	public class FacebookLoginTrigger : TriggerAction
	{
		protected override void Perform(Node target)
		{
			debug_log "Login to facebook";
			if defined(iOS) {
				var fb = new FacebookLogin();
				fb.ShowButton();
			}
		}

	}
