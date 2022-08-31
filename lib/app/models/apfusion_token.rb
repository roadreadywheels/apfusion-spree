class ApfusionToken < ActiveRecord::Base
  def get_scope
    urls = {
      'development' => 'https://staging.apfusion.com/',
      'staging' => 'https://staging.apfusion.com/',
      'production' => 'https://apfusion.com/'
    }
    try(:scope) || urls[Rails.env]
  end

  def get_token
    try(:token) || ''
  end
end
