class EmailAddress < ApplicationRecord
  belongs_to :contact
  belongs_to :label, optional: true

  validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
end
