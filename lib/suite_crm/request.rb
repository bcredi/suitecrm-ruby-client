require 'json'

module SuiteCrm
  class Request
    SUITE_CRM_API = '/service/v4_1/rest.php' 

    def initialize(http_client)
      @http_client = http_client
    end

    def call(method:, params:)
      @http_client.post SUITE_CRM_API, request_params(method, params)
    end

    private

    def request_params(method, params)
      {
        method: method,
        input_type: 'JSON',
        response_type: 'JSON',
        rest_data: JSON.generate(params)
      }
    end
  end
end
