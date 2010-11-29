class Comment
  include ActionView::Helpers::TextHelper # truncate
  
  def to_twin_hash
    { :id => self.id,
      :text => truncate(self.body, 140),
      :user => self.user,
      :created_at => self.created_at.to_time
    }
  end
end

class User
  def to_twin_hash
    { :id => self.id,
      :screen_name => self.username,
      :name => self.full_name,
      :profile_image_url => self.avatar.url,
      :description => self.bio,
      :created_at => self.created_at.to_time
    }
  end
  
  # NOTE: if your app doesn't have user avatars, but has user emails,
  # you can return :email instead of :profile_image_url and Twin will use Gravatar.
end
