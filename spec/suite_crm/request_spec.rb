RSpec.describe SuiteCrm::Request do
  describe '#call' do
    let(:http_client) { spy('http_client') }
    subject { SuiteCrm::Request.new(http_client) }
    before { subject.call(method: 'login', params: {}) }

    it do
      endpoint = "/service/v4_1/rest.php"
      params = {input_type: "JSON", method: "login", response_type: "JSON", rest_data: "{}"}
      expect(http_client).to have_received(:post).with(endpoint, params)
    end 
  end
end
