module PowerDNS
  class Record < ActiveRecord::Base
    self.inheritance_column = nil
    belongs_to :domain
  end
end
