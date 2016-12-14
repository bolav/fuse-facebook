# Fuse Facebook Login

Example to log in with [Facebook](https://www.facebook.com/) in [Fuse](http://www.fusetools.com/).

This is only a proof of concept.

![Screenshot](https://raw.githubusercontent.com/bolav/fuse-facebook-login/master/LogIn.png)
![Screenshot](https://raw.githubusercontent.com/bolav/fuse-facebook-login/master/LogOut.png)

## Usage

Fix your unoproj:
    "Facebook": {
      "AppID": "APPID_HERE",
      "CFBundleURLSchemes": "URL_SCHEME_HERE"
    },

Add the button to your UX:

     <NativeViewHost>
       <FBLoginButton />
     </NativeViewHost>

Or log in with JavaScript:

    var facebook = require('Facebook/Login');
    facebook.login();

Call Me function after logged in:

    facebook.me().then(function (js) {
    	console.log(js);
    });

## Issues

* Need callback on successful login

## License

* MIT


https://developers.facebook.com/docs/ios/getting-started#sdk