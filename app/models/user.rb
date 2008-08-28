# == Schema Information
# Schema version: 20080828215249
#
# Table name: users
#
#  id                        :integer(11)     not null, primary key
#  login                     :string(255)     
#  email                     :string(255)     
#  crypted_password          :string(40)      
#  salt                      :string(40)      
#  created_at                :datetime        
#  updated_at                :datetime        
#  remember_token            :string(255)     
#  remember_token_expires_at :datetime        
#  activation_code           :string(40)      
#  activated_at              :datetime        
#  url_slug                  :string(255)     
#  inviter_id                :integer(11)     
#

require 'digest/sha1'
class User < ActiveRecord::Base

  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  
  belongs_to :inviter, :class_name => 'User'
  has_one :photo, :dependent => :destroy
  
  has_many :claims, :order => 'created_at ASC'
  has_many :sites, :through => :claims
  has_many :namings
  has_many :people
  
  before_save   :encrypt_password
  before_create :make_activation_code 
  after_create  :deliver_signup_notification
  after_save    :deliver_activation

  attr_accessible :login, :email, :password, :password_confirmation, :photo_file

  acts_as_slugable :source_column => :login

  def name
    login
  end
  
  def to_param
    url_slug
  end
  
  def colleages
    sites.collect {|s| s.users}.flatten - [self]
  end
  
  def represented_people
    sites.collect {|s| s.people}.flatten.uniq - people
  end
  
  def representing_namings
    represented_people.collect {|p| p.namings}.flatten.select {|c| !sites.include?(c.site)}
  end
  
  def self.find_linking_to(user)
    sites = user.claims.map(&:site) # TODO: same as user.sites? [thorsten, 29.08.2008]
    namings_for_sites = sites.collect {|site| site.namings}.flatten
    namings_for_sites.map(&:user).uniq - [user]
  end
  
  def photo_file=(photo_file)
    unless photo_file.blank?
      self.create_photo(:uploaded_data => photo_file, :user_id => self.id)
    end
  end

  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  private
    def deliver_signup_notification
      UserMailer.deliver_signup_notification(self)
    end
    
    def deliver_activation
      UserMailer.deliver_activation(self) if self.recently_activated?
    end
    
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
end
