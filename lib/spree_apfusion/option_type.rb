module SpreeApfusion
  class OptionType

    def self.create option_type
      @option_type = option_type
      SpreeApfusion::OptionType.generate_option_type_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/option_types.json', {option_type: @option_type_hash})
    end

    def self.update option_type
      @option_type = option_type

      p "========UPDate call====="
      p @option_type.id
      SpreeApfusion::OptionType.generate_option_type_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/option_types/'+@option_type.id.to_s+'.json', {option_type: @option_type_hash})
    end

    def self.destroy option_type
      @option_type = option_type
      p "========Delete call====="
      p @option_type.id
      SpreeApfusion::OptionType.generate_option_type_hash
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/option_types/'+@option_type.id.to_s+'.json', {option_type: @option_type_hash})
    end
      
  

    def self.generate_option_type_hash 
      @option_type_hash = @option_type.attributes
    end

  end
end