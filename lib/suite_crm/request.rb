require 'faraday'
require 'json'

module SuiteCrm
  class Request
    def initialize(faraday)
      @conn = faraday
    end

    def call(method:, params:)
      @conn.post '/service/v4_1/rest.php', request_params(method, params)
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
