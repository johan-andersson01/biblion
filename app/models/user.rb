class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_create :create_activation_digest
  before_save { email.downcase!}
  validates :name, presence: true, length: {
    maximum: 1,
    tokenizer: lambda { |str| str.split(/\s+/) },
    too_long: "must be only %{count} word"
  }, length: {minimum 2, maximum: 20}
  validates :location, presence: true, length: {minimum: 2, maximum: 40}
  validates :landscape, presence: true, length: {minimum: 2, maximum 20}
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {minimum: 5, maximum: 255},
  format: {with: VALID_EMAIL}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: { minimum: 8}, allow_nil: true
  validates :terms_of_service, acceptance: true
  has_many :books, dependent: :destroy

  def self.search(query)
    where("LOWER(location) LIKE ?", "%#{query}%").or(where("LOWER(landscape) LIKE ?", "%#{query}%"))
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
