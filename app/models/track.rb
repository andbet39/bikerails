class Track < ActiveRecord::Base
    has_attached_file :gpx
    do_not_validate_attachment_file_type :gpx

    has_many :points, -> { order 'time asc' }
    
    def bounds
        max_lat = self.points.max_by(&:lat).lat
        min_lat = self.points.min_by(&:lat).lat
        max_lng = self.points.max_by(&:lng).lng
        min_lng = self.points.min_by(&:lng).lng
    
        bounds={ "min_lat" => min_lat , "max_lat"=>max_lat , "min_lon" => min_lng, "max_lon" => max_lng }
    
        return bounds
    end
end
