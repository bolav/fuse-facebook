# Fuse Facebook Login

Example to log in with [Facebook](https://www.facebook.com/) with [Fuse](http://www.fusetools.com/).

This is only a proof of concept.

![Screenshot](https://raw.githubusercontent.com/bolav/fuse-facebook-login/master/LogIn.png)
![Screenshot](https://raw.githubusercontent.com/bolav/fuse-facebook-login/master/LogOut.png)

## Usage

Register callback:

```
<FBiOS ux:Global="_fbios"/>
```

Add the button to your UX:

```
<FBLoginButton HitTestMode="LocalBoundsAndChildren">
	<FBLoginButtonImpl />
</FBLoginButton>
```

## Issues

* Only iOS support for now. (Android on the list).
* Only FB-button support. (Custom button coming).
* Will ask for login each time.

## License

* MIT