module SpreeApfusion
  class OAuth
		
  	def self.init
			# @url = 'https://www.apfusion_auth.com'
			@url = 'http://localhost:3000'
			@grant_type = 'client_credentials'
			
			# @apfusion_auth_config = YAML.load_file(Rails.root.to_s + '/config/apfusion_auth_config.yml')[Rails.env]
			@apfusion_auth_config = YAML.load_file('/Users/afzal/rails/gems/spree_apfusion/config/apfusion_auth_config.yml')[Rails.env]
			@public_key = @apfusion_auth_config['public_key']
			@secret_key = @apfusion_auth_config['secret_key']
			@access_token = ApfusionToken.first.try(:token)
		end

		def self.get_access_token
			begin	
				request = RestClient.post(@url+'/oauth/token', {client_id: @public_key, client_secret: @secret_key, grant_type: @grant_type})
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
			if ApfusionToken.first.present?
				ApfusionToken.first.update_attributes(token: @access_token)
			else
				ApfusionToken.create(token: @access_token)
			end
		end

		def self.authorize
			SpreeApfusion::OAuth.init
			if @access_token.blank?
				response = SpreeApfusion::OAuth.get_access_token
				unless response[:success]
					return response
				end
			end

			{status: 'Authorized!', access_token: @access_token}
		end

		def self.send (url_path, data)
			SpreeApfusion::OAuth.init
			
			if @access_token.blank?
				response = SpreeApfusion::OAuth.get_access_token
				unless response[:success]
					return response
				end
			end

			begin
				
				request = RestClient.post(@url+url_path, data)
				
				if request.present?
					return JSON.parse(request.body)
				else
					return {success: false, response: 'Error! Unable to send data.'}
				end
			
			rescue => e
				error = e.as_json
				if error == "401 Unauthorized" || error['initial_response_code'] == 401
					ApfusionToken.destroy_all
					SpreeApfusion::OAuth.push(url_path, data)
				else
					if error.is_a? String
						return {success: false, response: "#{error} - In sending data."}
					else
						return {success: false, response: JSON.parse(error['response'].body), response_code: error['initial_response_code']}
					end
				end
			
			end
		end

	end
end
