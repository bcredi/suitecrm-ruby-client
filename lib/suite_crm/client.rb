require 'faraday'
require 'digest/md5'

module SuiteCrm
  class Client
    attr_reader :conn

    def initialize(endpoint: nil, conn: nil)
      @session_id = nil
      @conn = conn || ::Faraday.new(url: endpoint) do |faraday|
        faraday.request :url_encoded
        faraday.adapter ::Faraday.default_adapter
      end
    end

    def login(username:, password:)
      params = {
        'user_auth' => {
          'user_name' => username,
          'password' => Digest::MD5.hexdigest(password)
         },
         'application_name' => '',
         'name_value_list' => []
      }

      request = SuiteCrm::Request.new(@conn).call(method: 'login', params: params)
      response = JSON.parse(request.body)
      return response if invalid_credentials? response
      return authenticate(response)
    end

    def authenticated?
      not @session_id.nil?
    end

    private

    def authenticate(response)
      @session_id = response['id']
      response
    end

    def invalid_credentials?(response)
      response['number'] == 10
    end
  end
end
