class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  before_create :set_identifier, if: -> { self.class.column_names.include?("identifier") }

  def set_identifier
    self.identifier = SecureRandom.uuid
  end

  def find_by_identifier(identifier)
    self.class.find_by(identifier: identifier)
  end
end
