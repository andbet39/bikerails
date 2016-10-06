class Meeting < ActiveRecord::Base
    belongs_to :ride_level
    belongs_to :ride_type
    belongs_to :track
end
