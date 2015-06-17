class User < ActiveRecord::Base
  attr_accessor :remember_token,  :activation_token
  before_create :create_activation_digest
  before_save	{	self.email	=	email.downcase	}
  attr_accessor :remember_token

  validates_presence_of :name,:email,:password,:password_confirmation

  has_secure_password

  def	User.digest string
    cost	=	ActiveModel::SecurePassword.min_cost	?	BCrypt::Engine::MIN_COST	:
    BCrypt::Engine.cost
    BCrypt::Password.create(string,	cost:	cost)
  end

  def	User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
      #	Returns	true	if	the	given	token	matches	the	digest.
  def	authenticated? attribute, token
    digest=send("#{attribute}_digest")
    #return false if digest nill?
    BCrypt::Password.new(digest).is_password?(token)
  end
  def forget
      #update_attribute(:remember_digest,nill)
  end
    # Activates an  account.
    def activate
        update_attribute(:activated,        true)
        update_attribute(:activated_at, Time.zone.now)
    end
    # Sends activation  email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
  private
  def create_activation_digest
    self.activation_token   = User.new_token
    self.activation_digest  = User.digest(activation_token)
  end
end
