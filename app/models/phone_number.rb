class PhoneNumber < ApplicationRecord
  belongs_to :contact
  belongs_to :label, optional: true

  validates :country_code, presence: true, length: { maximum: 10 }
  validates :main, presence: true, length: { maximum: 20 }, format: { with: /\A\+?[0-9\s\-()]+\z/, message: "only allows numbers, spaces, dashes, and parentheses" }
end
