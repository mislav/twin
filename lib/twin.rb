require 'rack/request'
require 'active_support/core_ext/hash/conversions'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/json'
# Active Support 2 doesn't have the following file, but it's OK
# since we already got the method from "hash/conversions"
require 'active_support/core_ext/object/to_query' unless {}.respond_to? :to_query
require 'digest/md5'

class Twin
  X_CASCADE = 'X-Cascade'.freeze
  PASS      = 'pass'.freeze
  PATH_INFO = 'PATH_INFO'.freeze
  AUTHORIZATION = 'HTTP_AUTHORIZATION'.freeze
  
  attr_accessor :request, :format, :captures, :content_type, :current_user
  
  class << self
    attr_accessor :resources
  end
  
  self.resources = []
  
  def self.resource(path, &block)
    reg = %r{^/(?:1/)?#{path}(?:\.(\w+))?$}
    self.resources << [reg, block]
  end
  
  DEFAULT_OPTIONS = { :model => 'TwinAdapter' }
  
  def initialize(app, options = {})
    @app = app
    @options = DEFAULT_OPTIONS.merge options
  end
  
  def call(env)
    path = normalize_path(env[PATH_INFO])
    matches = nil
    
    if path != '/' and found = recognize_resource(path)
      block, matches = found
      
      # TODO: bail out early if authentication failed
      twin_token = env[AUTHORIZATION] =~ / oauth_token="(.+?)"/ && $1
      authenticated_user = twin_token && model.find_by_twin_token(twin_token)
      
      clone = self.dup
      clone.request = Rack::Request.new env
      clone.captures = matches[1..-1]
      clone.format = clone.captures.pop
      clone.current_user = authenticated_user
      
      clone.perform block
    else
      # [404, {'Content-Type' => 'text/plain', X_CASCADE => PASS}, ['Not Found']]
      @app.call(env)
    end
  end
  
  def recognize_resource(path)
    matches = nil
    pair = self.class.resources.find { |reg, block| matches = path.match(reg) }
    pair && [pair[1], matches]
  end
  
  def perform(block)
    response = instance_eval &block
    generate_response response
  end

  # x_auth_mode => "client_auth"
  resource 'oauth/access_token' do
    if user = model.authenticate(params['x_auth_username'], params['x_auth_password'])
      user_hash = normalize_user(user)
      token = user_hash[:twin_token] || model.twin_token(user)
      
      self.content_type = 'application/x-www-form-urlencoded'
      
      { :oauth_token => token,
        :oauth_token_secret => 'useless',
        :user_id => user_hash[:id],
        :screen_name => user_hash[:screen_name],
        :x_auth_expires => 0
      }
      # later sent back as: oauth_token="..."
    else
      [400, {'Content-Type' => 'text/plain'}, ['Bad credentials']]
    end
  end
  
  protected
  
  class Response
    def initialize(name, object)
      @name = name
      @object = object
    end
    
    def to_xml
      @object.to_xml(:root => @name, :dasherize => false, :skip_types => true)
    end
    
    def to_json
      @object.to_json
    end
  end
  
  def respond_with(name, values)
    Response.new(name, values)
  end
  
  def params
    request.params
  end
  
  def model
    @model ||= constantize(@options[:model])
  end
  
  def not_found
    [404, {'Content-Type' => 'text/plain'}, ['Not found']]
  end
  
  def not_implemented
    [501, {'Content-Type' => 'text/plain'}, ['Not implemented']]
  end
  
  def normalize_statuses(statuses)
    statuses.map do |status|
      hash = convert_twin_hash(status)
      hash[:user] = normalize_user(hash[:user])
      DEFAULT_STATUS_PARAMS.merge hash
    end
  end
  
  def normalize_user(user)
    hash = convert_twin_hash(user)
    
    if hash[:email] and not hash[:profile_image_url]
      # large avatar for iPhone with Retina display
      hash[:profile_image_url] = gravatar(hash.delete(:email), 96, 'identicon')
    end
    
    DEFAULT_USER_INFO.merge hash
  end
  
  def convert_twin_hash(object)
    if Hash === object then object
    elsif object.respond_to? :to_twin_hash
      object.to_twin_hash
    elsif object.respond_to? :attributes
      object.attributes
    else
      object.to_hash
    end.symbolize_keys
  end
  
  def gravatar(email, size = 48, default = nil)
    gravatar_id = Digest::MD5.hexdigest email.downcase
    url = "http://www.gravatar.com/avatar/#{gravatar_id}?size=#{size}"
    url << "&default=#{default}" if default
    return url
  end
  
  private
  
  def content_type_from_format(format)
    case format
    when 'xml' then 'application/xml'
    when 'json' then 'application/x-json'
    end
  end
  
  def serialize_body(body)
    if String === body
      body
    else
      case self.content_type
      when 'application/xml' then body.to_xml
      when 'application/x-json' then body.to_json
      when 'application/x-www-form-urlencoded' then body.to_query
      else
        raise "unrecognized content type: #{self.content_type.inspect} (format: #{self.format})"
      end
    end
  end
  
  def generate_response(response)
    if Array === response then response
    else
      self.content_type ||= content_type_from_format(self.format)
      [200, {'Content-Type' => self.content_type}, [serialize_body(response)]]
    end
  end
  
  # Strips off trailing slash and ensures there is a leading slash.
  def normalize_path(path)
    path = "/#{path}"
    path.squeeze!('/')
    path.sub!(%r{/+\Z}, '')
    path = '/' if path == ''
    path
  end
  
  def constantize(name)
    if Module === name then name
    elsif name.to_s.respond_to? :constantize
      name.to_s.constantize
    else
      Object.const_get name
    end
  end
end

require 'twin/resources'
