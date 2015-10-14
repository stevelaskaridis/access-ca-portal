class DistinguishedName < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
end
