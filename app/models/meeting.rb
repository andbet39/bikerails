class Meeting < ActiveRecord::Base

    acts_as_mappable :default_units => :kms,
                     :lat_column_name => :start_lat,
                     :lng_column_name => :start_lng


    belongs_to :ride_level
    belongs_to :ride_type
    belongs_to :track
    belongs_to :user

    has_many :participations
    has_many :users, :through => :participations

    def as_json(options={})
        super(include: [ :participations,:track,:user])
    end

end
