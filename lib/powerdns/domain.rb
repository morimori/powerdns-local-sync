module PowerDNS
  class Domain < ActiveRecord::Base
    self.inheritance_column = nil
    has_many :records
  end
end
