require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  belongs_to :lab
  has_many :entries
  has_many :maintenance_entries
  
  validates :lab, :presence => true
  validates :email, :uniqueness => true, :length => { :within => 5..50 },
                                          :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  validates :password, :confirmation => true,
                        :length => {:within => 4..20},
                        :presence => true,
                        :if => :password_required?

  before_save :encrypt_new_password

  def self.authenticate(email, password)
    user = find_by_email(email)
    return user if user && user.authenticated?(password)
  end
  
  def self.roles_for_select
    available_roles.to_a
  end
  
  def self.available_roles
    {'operator' => 0, 'admin' => 1, 'manager' => 2, 'disabled' => -1}
  end

  def authenticated?(password)
    self.hashed_password == encrypt(password)
  end
  
  def admin?
    !self.role.nil? && self.role == 1 ? true : false
  end
  
  def manager?
    !self.role.nil? && self.role != 0 ? true : false
  end
  
  def disabled?
    !self.role.nil? && self.role == -1 ? true : false
  end
  
  def name
    /(^.+?)@/.match(email) {|m| m[1]}
  end
  
  def role_name
    User.available_roles.key(role)
  end
  

  
  protected

    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password)
    end

    def password_required?
      hashed_password.blank? || password.present?
    end

    def encrypt(string)
      Digest::SHA1.hexdigest(string)
    end
end
