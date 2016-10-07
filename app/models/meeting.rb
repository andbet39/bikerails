class Meeting < ActiveRecord::Base
    belongs_to :ride_level
    belongs_to :ride_type
    belongs_to :track
    belongs_to :user

    has_many :participations
    has_many :users, :through => :participations
end
