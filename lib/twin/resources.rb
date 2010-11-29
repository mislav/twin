class Twin
  resource 'statuses/home_timeline' do
    statuses = self.model.statuses(params.with_indifferent_access, current_user)
    respond_with('statuses', normalize_statuses(statuses))
  end
  
  resource 'users/show' do
    user = if params['screen_name']
      self.model.find_by_username params['screen_name']
    elsif params['user_id']
      self.model.find_by_id params['user_id']
    end
    
    if user
      respond_with('user', normalize_user(user))
    else
      not_found
    end
  end
  
  resource 'account/verify_credentials' do
    respond_with('user', normalize_user(current_user))
  end
  
  resource 'friendships/show' do
    source_id = params['source_id']
    target_id = params['target_id']
    
    respond_with('relationship', {
      "target" => {
        "followed_by" => true,
        "following" => false,
        "id_str" => target_id.to_s,
        "id" => target_id.to_i,
        "screen_name" => ""
      },
      "source" => {
        "blocking" => nil,
        "want_retweets" => true,
        "followed_by" => false,
        "following" => true,
        "id_str" => source_id.to_s,
        "id" => source_id.to_i,
        "screen_name" => "",
        "marked_spam" => nil,
        "all_replies" => nil,
        "notifications_enabled" => nil
      }
    })
  end

  resource 'statuses/(?:replies|mentions)' do
    respond_with('statuses', [])
  end
  
  resource '(\w+)/lists(/subscriptions)?' do
    respond_with('lists_list', {:lists => []})
  end
  
  resource 'direct_messages(/sent)?' do
    respond_with('direct-messages', [])
  end
  
  resource 'account/rate_limit_status' do
    reset_time = Time.now + (60 * 60 * 24)
    respond_with(nil, {
      'remaining-hits' => 100, 'hourly-limit' => 100,
      'reset-time' => reset_time, 'reset-time-in-seconds' => reset_time.to_i
    })
  end
  
  resource 'saved_searches' do
    respond_with('saved_searches', [])
  end
  
  resource 'account/(settings|apple_push_destinations(/(destroy|device))?)' do
    not_implemented
  end
  
  DEFAULT_STATUS_PARAMS = {
    :id => nil,
    :text => "",
    :user => nil,
    :created_at => "Mon Jan 01 00:00:00 +0000 1900",
    :source => "web",
    :coordinates => nil,
    :truncated => false,
    :favorited => false,
    :contributors => nil,
    :annotations => nil,
    :geo => nil,
    :place => nil,
    :in_reply_to_screen_name => nil,
    :in_reply_to_user_id => nil,
    :in_reply_to_status_id => nil
  }
  
  DEFAULT_USER_INFO = {
    :id => nil,
    :screen_name => nil,
    :name => "",
    :description => "",
    :profile_image_url => nil,
    :url => nil,
    :location => nil,
    :created_at => "Mon Jan 01 00:00:00 +0000 1900",
    :profile_sidebar_fill_color => "ffffff",
    :profile_background_tile => false,
    :profile_sidebar_border_color => "ffffff",
    :profile_link_color => "8b8b9c",
    :profile_use_background_image => false,
    :profile_background_image_url => nil,
    :profile_background_color => "FFFFFF",
    :profile_text_color => "000000",
    :follow_request_sent => false,
    :contributors_enabled => false,
    :favourites_count => 0,
    :lang => "en",
    :followers_count => 0,
    :protected => false,
    :geo_enabled => false,
    :utc_offset => 0,
    :verified => false,
    :time_zone => "London",
    :notifications => false,
    :statuses_count => 0,
    :friends_count => 0,
    :following => true
  }
  
  # direct_message
  #   :id
  #   :sender_id
  #   :text
  #   :recipient_id
  #   :created_at
  #   :sender_screen_name
  #   :recipient_screen_name
  #   :sender
  #   :recipient
end
