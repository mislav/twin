Twitter's Twin
==============

<i>Twin</i> is a Rack middleware which provides your app with a subset of Twitter's API. In other words, it makes your app respond to certain requests as if it were "api.twitter.com".

This is useful in combination with Twitter clients which allow you to change the hostname used for API requests. If your Twitter client allows you to configure it to fetch updates from "yourapp.net" instead of "api.twitter.com", you could serve fake "tweets" from your app and use the Twitter client to read them.

**Twitter for iPhone** is a free client that allows you to customize the hostname. (Its version for iPad does not, for some reason.) Known desktop clients that support the same are [Twitterrific][] and [Spaz][].

Two popular websites which already implement the Twitter API are [WordPress.com][wp] and [Tumblr][]. Twin is a library for Ruby apps to do the same.


Installation
------------

For Ruby on Rails, add "twin" to your Gemfile. For other apps, a little bit more is needed:

    ## Gemfile for non-Rails apps
    gem 'twin'
    gem 'i18n'    # not really used; needed to load some part of Active Support
    gem 'builder' # used for constructing XML responses

Twin's dependency is Active Support, from which only few bits are loaded.

Now, mount "Twin" as middleware:

    ## Ruby on Rails
    config.middleware.use Twin
    
    ## Sinatra
    use Twin


Data models
-----------

Twin uses a model named by default "TwinAdapter" to fetch records from your app. You have to write this model yourself and implement several methods to define which data sent back to the client.

The template for TwinAdapter is available in ["example/twin_adapter.rb"][adapter].

The adapter should return two types of records: one representing twitter "statuses" and the other representing users. Both types of records should either be hashes containing twitter-compatible keys or they should implement the `to_twin_hash` method that returns such values.

Examples for implementing `to_twin_hash` for typical Active Record models is in ["example/to_twin_hash.rb"][hash].


Configuring Twitter for iPhone
------------------------------

With Twin middleware and data models in place, your app is ready to receive requests from Twitter clients. To try this out with Twitter for iPhone, go to the "Accounts" page and start creating a new account. Before submitting the username and password, tap the cogwheel to access the advanced configuration screen. Type in your hostname for "API root", return back and finish the process.

![Advanced configuration screen displaying "http://example.com"](http://img.skitch.com/20101129-fab66pj66hcqwu5wbwf3ci3y8f.png)

Using Twitter for iPhone in this manner may not be without bugs. This client caches user info based on screen name, *regardless* of the host where they come from. If a user from your Twin-enabled app shares the same screen name as an existing Twitter user, their info (and avatar pictures) might mix.


API support
-----------

Twin doesn't implement the full Twitter API — far from it. It only implements the basic subset required to read the main timeline. Posting is not yet implemented. Replies/mentions, lists, saved searches and direct messages are not functional; their read APIs are implemented but they return empty collections. There is no rate limiting.

To see which APIs are implemented, [check out "twin/resources.rb"][resources].


Credits
-------

Twin was written by Mislav Marohnić for [Teambox](http://teambox.com) and later extracted into a reusable library after a [gentle nudge by Shane Becker][shane].


[spaz]: http://getspaz.com/
[twitterrific]: http://iconfactory.com/software/twitterrific
[adapter]: https://github.com/mislav/twin/blob/master/example/twin_adapter.rb
[hash]: https://github.com/mislav/twin/blob/master/example/to_twin_hash.rb
[resources]: https://github.com/mislav/twin/blob/master/lib/twin/resources.rb
[wp]: http://en.support.wordpress.com/twitter-api/ "WordPress.com Twitter API"
[tumblr]: http://staff.tumblr.com/post/287703110/api
[shane]: http://iamshane.com/articles/2010/11/9/1/twitter-clone-gem "We need a Twitter API clone Ruby Gem"
