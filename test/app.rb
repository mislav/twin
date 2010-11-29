# encoding: utf-8
require 'sinatra'
require 'twin'

unless settings.run?
  set :logging, false
  use Rack::CommonLogger, File.open(File.join(settings.root, 'request.log'), 'a')
end

use Twin, :model => 'Adapter'

USERS = [
  { :id => 1, :screen_name => 'mislav', :name => 'Mislav Marohnić', :email => 'mislav.marohnic@gmail.com'},
  { :id => 2, :screen_name => 'veganstraightedge', :name => 'Shane Becker', :email => 'veganstraightedge@gmail.com'}
  ]

STATUSES = [
  { :id => 1, :text => 'Hello there! What a weird test', :user => USERS[0] },
  { :id => 2, :text => 'The world needs this.', :user => USERS[1] }
  ]

module Adapter
  def self.authenticate(username, password)
    username == password and find_by_username(username)
  end
  
  def self.twin_token(user)
    user[:email]
  end
  
  def self.statuses(params)
    STATUSES
  end
  
  def self.find_by_twin_token(token)
    find_by_key(:email, token)
  end
  
  def self.find_by_id(value)
    find_by_key(:id, value)
  end
  
  def self.find_by_username(value)
    find_by_key(:screen_name, value)
  end
  
  def self.find_by_key(key, value)
    USERS.find { |user| user[key] == value }
  end
end

get '/' do
  "Hello from test app"
end

error 404 do
  'No match'
end
