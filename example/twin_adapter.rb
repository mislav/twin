module TwinAdapter
  def self.statuses(params, current_user)
    limit = params[:count] || 20
    params[:since_id]  # fetch only records with IDs greater than this
    params[:max_id]    # fetch only records up to this ID
    
    # fetch array of records representing statuses for current user.
    # respect the given params for increased performance
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