Twitter's Twin
==============

<i>Twin</i> is a Rack middleware which provides your app with a subset of Twitter's API. In other words, it makes your app act like api.twitter.com.

This is useful for Twitter clients which allow you to change the hostname used for API requests. If your Twitter client allows you to configure it to fetch updates from "yourapp.net" instead of "api.twitter.com", you could serve fake "tweets" from your app and use the Twitter client to read them.

**Twitter for iPhone** is a popular, free Twitter client that allows you to do this. (Its counterpart for iPad does not, for some reason.)


Installation and usage
----------------------

Until I write this section, take a look at "test/app.rb" for an example how to mount Twin in Sinatra.


Credits
-------

Twin was extracted from [Teambox](http://teambox.com) with their permission. Thanks guys!