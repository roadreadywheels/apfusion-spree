module SpreeApfusion
  class OptionValue

    def self.create option_value
      @option_value = option_value
      @option_value_hash 
      SpreeApfusion::OptionValue.generate_option_value_hash 
      response = SpreeApfusion::OAuth.send(:post, '/api/v2/option_values.json', {option_value: @option_value_hash})
      if response[:success] == true                 
        @option_value.update_attributes(apfusion_option_value_id: response[:response]["id"])
      end  
    end

    def self.update option_value
      @option_value = option_value
      @option_value.id
      SpreeApfusion::OptionValue.generate_option_value_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/option_values/'+@option_value.apfusion_option_value_id.to_s+'.json', {option_value: @option_value_hash})
    end


    def self.destroy option_value
      @option_value = option_value
      @option_value.id
      SpreeApfusion::OptionValue.generate_option_value_hash 
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/option_values/'+@option_value.apfusion_option_value_id.to_s+'.json', {option_value: @option_value_hash})
    end


    def self.generate_option_value_hash 
      @option_value_hash = @option_value.attributes
      @option_value_hash["option_type_id"] = @option_value.option_type.apfusion_option_type_id
    end

  end
end