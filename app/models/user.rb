class User < ActiveRecord::Base

  attr_accessible :avatar

  has_one :address, :dependent => :destroy
  has_many :orders
  has_many :sessions
  has_many :blogs, :dependent => :destroy
  has_many :restaurants
  has_and_belongs_to_many :roles
  has_many :services, :dependent => :destroy
  has_many :ratings


  apply_simple_captcha :message => "The secret Image and code were different", :add_to_base => true
  has_one :address
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :name, :login, :password_confirmation, :remember_me, :captcha,:captcha_key, :phone, :avatar, :role_ids, :address_id
  # attr_accessible :title, :body
  attr_accessor :validation_confirm
  #cattr_accessor :skip_callbacks
  before_create :check_captcha
  validates_presence_of :login
  validates :login, uniqueness: true
  #validate :check_capture
  #skip_callback :before_save



  has_attached_file :avatar,
                    :url  => "/uploads/images/users/:id/:style/:filename.:extension",
                    :default_url => "/assets/imagenotavailable.png",
                    :path => ":rails_root/public/uploads/images/users/:id/:style/:filename.:extension",
                    :styles => { :medium => "300x300>", :thumb => "100x100>" }



  def check_captcha

    self.valid_with_captcha? unless  validation_confirm == 'api'
  end

  def role?(role)
    self.roles.find_by_name(role.to_s.camelize)
  end






end
