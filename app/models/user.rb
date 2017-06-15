class User < ApplicationRecord
#  attr_accessor :terms_of_service
  attr_accessor :remember_token
  before_save { email.downcase!}
  validates :name, presence: true, length: {minimum: 2, maximum: 50}
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_TEL = /\A[\d]+\z/i #/\Ad{8,11}\z
  validates :email, presence: true, length: {minimum: 5, maximum: 255},
  format: {with: VALID_EMAIL}, uniqueness: {case_sensitive: false}
  validates :telephone, presence: true, length: {minimum: 8, maximum: 11}, format: {with: VALID_TEL}
  has_secure_password
  validates :password, presence: true, length: { minimum: 6}
  #validates_acceptance_of :terms_of_service, :on => :create, acceptance: { accept: true}

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
