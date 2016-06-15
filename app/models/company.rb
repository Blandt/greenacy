class Company < ActiveRecord::Base
    validates :contact_number,    uniqueness: true
end
