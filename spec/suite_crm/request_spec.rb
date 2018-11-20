RSpec.describe SuiteCrm::Request do
  describe '#call' do
    it 'authenticate' do
      faraday = ::Faraday.new(:url => 'http://crm-staging.bcredi.com.br') do |faraday|
        faraday.request :url_encoded
        faraday.adapter ::Faraday.default_adapter
      end

      params = {
        'user_auth' => {
          'user_name' => 'apitest',
          'password' => Digest::MD5.hexdigest('123456')
        },
        'application_name' => '',
        'name_value_list' => []
      }

      resp = SuiteCrm::Request.new(faraday)
                              .call(method: 'login', params: params)
                              .body

      expect(resp).to eq(true)
    end
  end
end
