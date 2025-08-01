class User < ApplicationRecord
  has_many :user_kanjis
  has_many :kanjis, through: :user_kanjis

  # before_create :generate_jti

  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # private

  # def generate_jti
  #   self.jti ||= SecureRandom.uuid
  # end
end
