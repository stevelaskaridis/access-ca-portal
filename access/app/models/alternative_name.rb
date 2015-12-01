class AlternativeName < ActiveRecord::Base
  belongs_to :alternative_ident, polymorphic: true
  belongs_to :certificate

  validates :alternative_ident, presence: true
  validates_inclusion_of :alternative_ident_type, in: %w(Host Person)
end
