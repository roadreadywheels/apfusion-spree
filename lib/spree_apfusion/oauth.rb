module SpreeApfusion
  class OAuth

    def self.init
      record = SpreeApfusion::OAuth.apfusion_token_record
      @url = record.get_scope
      @access_token = record.get_token if record.present?
    end

    def self.get_access_token
      self.initialize_config_elements
      begin
        request = RestClient.post("#{@url}/oauth/token", {client_id: @public_key, client_secret: @secret_key, grant_type: self.grant_type})
        @access_token = JSON.parse(request.body)['access_token']
        SpreeApfusion::OAuth.update_token
        return {success: true}
      rescue => e
        error = e.as_json
        if error.is_a? String
          return {success: false, response: "#{error} - In getting access token."}
        else
          return {success: false, response: JSON.parse(error['response'].body), response_code: error['initial_response_code']}
        end
      end
    end

    def self.update_token
      ApfusionToken.first_or_create.update_attributes(token: @access_token)
    end

    def self.authorize
      SpreeApfusion::OAuth.init
      if @access_token.blank?
        response = SpreeApfusion::OAuth.get_access_token
        unless response[:success]
          return response
        end
      end

      { status: 'Authorized!', access_token: @access_token }
    end

    def self.send method, url_path, data
      p '========================'
      p "Method: #{method}"
      p "Url: #{url_path}"
      p "Params: #{data}"
      p '========================'
      SpreeApfusion::OAuth.authorize
      p 'after authorize called'
      request = self.client(url_path: url_path, method: method, data: data)

      begin
        response = request.execute {|response| $results = response}
        response_body = JSON.parse(response.body) if response.present?
        case response.code.to_s
        when /^20/
          p 'SYNC Successfully'
          return self.get_response(success: true, response_body: response_body, code: response.code)
        when '401'
          p '!!!!Invalid Access Token!!!!'
          ApfusionToken.destroy_all
          SpreeApfusion::OAuth.send(method, url_path, data)
        else
          return self.get_response(success: false, response_body: response_body, code: response.code)
        end
      rescue Exception => e
        p e.message
      end
    end

    def self.get_response success: false, response_body:, code:
      {
        success: success,
        response: response_body,
        response_code: code
      }
    end

    def self.client url_path:, method:, data:
      RestClient::Request.new(
        method: method,
        url: "#{@url}#{url_path}?access_token=#{@access_token}",
        headers: { params: data }
        )
    end

    def self.apfusion_token_record
      ApfusionToken.first_or_create
    end

    def self.grant_type
      'client_credentials'
    end

    def self.initialize_config_elements
      begin
        @apfusion_auth_config = YAML.load_file(Rails.root.to_s + '/config/apfusion_auth_config.yml')[Rails.env]
      rescue
        raise "
        \n===============================================================
        \n Please create a config file at /config/apfusion_auth_config.yml like the example given below
        \n===============================================================
        \ndevelopment:
        \n\tpublic_key: PUBLIC_KEY
        \n\tsecret_key: SECRET_KEY
        \n===============================================================\n"
      end
      # @apfusion_auth_config = YAML.load_file('/Users/afzal/rails/gems/spree_apfusion/config/apfusion_auth_config.yml')[Rails.env]
      @public_key = @apfusion_auth_config['public_key']
      @secret_key = @apfusion_auth_config['secret_key']
    end
  end
end
