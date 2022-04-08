module SpreeApfusion
  class Zone

    def self.create zone
      @zone = zone
      SpreeApfusion::Zone.generate_zone_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/zones.json', {zone: @zone_hash})
    end

    def self.update zone
      @zone = zone
      @zone.id
      SpreeApfusion::Zone.generate_zone_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/zones/'+@zone.id.to_s+'.json', {zone: @zone_hash})
    end

    def self.destroy zone
      @zone = zone
      @zone.id
      SpreeApfusion::Zone.generate_zone_hash
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/zones/'+@zone.id.to_s+'.json', {zone: @zone_hash})
    end
      
  

    def self.generate_zone_hash 
      @zone_hash = @zone.attributes
      SpreeApfusion::Zone.add_zone_members
    end

    def self.add_zone_members
        @zone_hash["country_ids"] = @zone.zone_members.collect(&:zoneable_id)    
    end

  end
end