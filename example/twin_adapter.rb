module TwinAdapter
  def self.statuses(params, current_user)
    limit = params[:count] || 20
    params[:since_id]  # fetch only records with IDs greater than this
    params[:max_id]    # fetch only records up to this ID
    
    # fetch array of records representing statuses for current user.
    # respect the given params for increased performance
    []
  end

  def self.mentions(params, current_user)
    # same as `statuses`
    []
  end

  def self.favorites(params, current_user, user_id = nil)
    # target user might be explicitly given by ID
    user = user_id ? find_by_id(user_id) : current_user
    
    limit = params[:count] || 20
    page = params[:page].to_i  # starts at 0
    params[:since_id]          # fetch only records with IDs greater than this
    
    # fetch array of favorite statuses
    []
  end
  
  def self.create_favorite(status_id, current_user)
    # no return value
  end
  
  def self.destroy_favorite(status_id, current_user)
    # no return value
  end
  
  def self.retweet(status_id, current_user)
    # no return value
  end
  
  def self.status_update(params, current_user)
    params[:in_reply_to_status_id]
    params[:status]
    
    # returns status as hash
    { id: ... }
  end
  
  def self.authenticate(username, password)
    # return authenticated user record
  end
  
  def self.twin_token(user)
    # return authentication token for a user. the token should never expire.
    # clients will later authenticate users with the token instead of username/password.
  end
  
  def self.find_by_twin_token(token)
    # find user by token
  end
  
  def self.find_by_id(user_id)
    # find user by ID
  end
  
  def self.find_by_username(name)
    # find user by username
  end
end