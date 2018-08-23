module SpreeApfusion
  class OptionValue

    def self.create option_value
      @option_value = option_value
      @option_value_hash 
      SpreeApfusion::OptionValue.generate_option_value_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/option_values.json', {option_value: @option_value_hash})
    end

    def self.update option_value
      @option_value = option_value

      p "========UPDate call Values====="
      p @option_value.id
      SpreeApfusion::OptionValue.generate_option_value_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/option_values/'+@option_value.id.to_s+'.json', {option_value: @option_value_hash})
    end


    def self.destroy option_value
      @option_value = option_value
      p "========Delete call====="
      p @option_value.id
      SpreeApfusion::OptionValue.generate_option_value_hash 
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/option_values/'+@option_value.id.to_s+'.json', {option_value: @option_value_hash})
    end


    def self.generate_option_value_hash 
      @option_value_hash = @option_value.attributes
    end

  end
end