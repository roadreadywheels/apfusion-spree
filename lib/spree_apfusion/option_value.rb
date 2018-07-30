module SpreeApfusion
  class OptionValue

    def self.create option_value
      @option_value = option_value
      @option_value_hash 
      SpreeApfusion::OptionValue.generate_option_value_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/option_values.json', {option_value: @option_value_hash})
    end

    def self.generate_option_value_hash 
      @option_value_hash = @option_value.attributes
    end

  end
end