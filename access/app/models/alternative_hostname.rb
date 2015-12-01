class AlternativeHostname < ActiveRecord::Base
  belongs_to :host
  has_many :alternative_names, as: :alternative_ident

  validates :address, presence: true, hostname: true
  validates :host, presence:true
end
