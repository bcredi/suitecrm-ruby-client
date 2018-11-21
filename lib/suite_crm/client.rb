require 'faraday'
require 'digest/md5'

module SuiteCrm
  class Client
    # = SuiteCrm::Client
    #
    # Use this to comunicate with the SuiteCrm api
    # After initialize the object, call the #login method to ensure your client can make calls
    #
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

    # Create or change an entry of *module_name*
    #
    # Params:
    # 
    # *module_name* is a module existent inside crm
    #
    # *data* is a list of hashes in the following format:
    #   [
    #     {'name' => 'key 1', 'value' => 'key value' },
    #     {'name' => 'key 2', 'value' => 'key value' }
    #   ]
    #
    def set_entry(module_name:, data:)
      params = {
        'session' => @session_id,
        'module_name' => module_name,
        'name_value_list' => data
      }

      request = SuiteCrm::Request.new(@conn).call(method: 'set_entry', params: params)
      response = JSON.parse(request.body)
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
