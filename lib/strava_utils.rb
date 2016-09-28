class StravaUtils

    def self.getSegments bounds

        @client = Strava::Api::V3::Client.new(:access_token => "6498cb0c67cb8b09af420e2856d006fe98b8f598")
        
        b =  {'bounds': bounds}
        segments = @client.segment_explorer(b)

        return segments
 
    end



end