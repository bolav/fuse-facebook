# Fuse Facebook Analytics

Example to use [Facebook](https://www.facebook.com/) Analytics with [Fuse](http://www.fusetools.com/).

## Usage

Fix your unoproj:

    "Facebook": {
      "AppID": "APPID_HERE",
      "CFBundleURLSchemes": "URL_SCHEME_HERE"
    },

Require:

    var analytics = require('Facebook/Analytics');

Log only name:

    analytics.logEvent("EventName");

Log with parameters:

    analytics.logEvent("EventName", {'one':'one','two':'two'});

Log with value:

    analytics.logEvent("EventName", 130);

Log with value and parameters:

    analytics.logEvent("EventName", 130, {'one':'one','two':'two'});

## License

* MIT
