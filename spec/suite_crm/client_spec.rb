RSpec.describe SuiteCrm::Client do
  describe '#login' do
    context 'valid credentials' do
      let(:response) { double('response', body: JSON.generate({"id" => "8q1sbc397sfqk27169ftj9vn20", "module_name" => "Users", "name_value_list" => {"user_id" => {"name" => "user_id", "value" => "25db1b2c-4534-6fb9-707b-5bf351386a63"}, "user_name"=>{"name"=>"user_name", "value"=>"apitest"}, "user_language"=>{"name"=>"user_language", "value"=>"en_us"}, "user_currency_id"=>{"name"=>"user_currency_id", "value"=>"-99"}, "user_is_admin"=>{"name"=>"user_is_admin", "value"=>true}, "user_default_team_id"=>{"name"=>"user_default_team_id", "value"=>nil}, "user_default_dateformat"=>{"name"=>"user_default_dateformat", "value"=>"Y-m-d"}, "user_default_timeformat"=>{"name"=>"user_default_timeformat", "value"=>"H:i"}, "user_number_seperator"=>{"name"=>"user_number_seperator", "value"=>","}, "user_decimal_seperator"=>{"name"=>"user_decimal_seperator", "value"=>"."}, "mobile_max_list_entries"=>{"name"=>"mobile_max_list_entries", "value"=>nil}, "mobile_max_subpanel_entries"=>{"name"=>"mobile_max_subpanel_entries", "value"=>nil}, "user_currency_name"=>{"name"=>"user_currency_name", "value"=>"US Dollar"}}})) }
      let(:conn) { double('http_client', post: response) }
      subject { SuiteCrm::Client.new(conn: conn) }
      it { expect(subject.login(username: 'valid', password: '123')).to be_an_instance_of Hash }

      it do
        subject.login(username: 'valid', password: '123')
        expect(subject.authenticated?).to eq true
      end
    end

    context 'invalid credentials' do
      let(:response) { double('response', body: JSON.generate({"name"=>"Invalid Login", "number"=>10, "description"=>"Login attempt failed please check the username and password"})) }
      let(:conn) { double('http_client', post: response) }
      subject { SuiteCrm::Client.new(conn: conn) }
      it { expect(subject.login(username: 'invalid', password: '123')).to be_an_instance_of Hash }
      it { expect(subject.authenticated?).to eq false }
    end
  end

  describe '#set_entry' do
    let(:response) { double('response', body: JSON.generate({"id"=>"6011cc41-31b6-c360-3cf1-5bf55a124a8c", "entry_list"=>{"title"=>{"name"=>"title", "value"=>"Api testing"}}})) }
    let(:conn) { double('http_client', post: response) }
    let(:data) {[{'name' => 'title', 'value' => 'Api testing'}]}
    subject { SuiteCrm::Client.new(conn: conn) }

    it { expect(subject.set_entry(module_name: 'Leads', data: data)).to be_an_instance_of Hash  }
  end

   describe '#get_entry' do
    context 'without select fields' do 
      let(:response) { double('response', body: JSON.generate({"id"=>"6011cc41-31b6-c360-3cf1-5bf55a124a8c", "entry_list"=>{"title"=>{"name"=>"title", "value"=>"Api testing"}}})) }
      let(:conn) { double('http_client', post: response) }
      let(:id) { '6011cc41-31b6-c360-3cf1-5bf55a124a8c' }
      subject { SuiteCrm::Client.new(conn: conn) }

      it { expect(subject.get_entry(module_name: 'Leads', id: id)).to be_an_instance_of Hash  }
    end

    context 'with select fields' do
      let(:response) { double('response', body: JSON.generate({"id"=>"6011cc41-31b6-c360-3cf1-5bf55a124a8c", "entry_list"=>{"title"=>{"name"=>"title", "value"=>"Api testing"}}})) }
      let(:conn) { double('http_client', post: response) }
      let(:id) { '6011cc41-31b6-c360-3cf1-5bf55a124a8c' }
      subject { SuiteCrm::Client.new(conn: conn) }

      it { expect(subject.get_entry(module_name: 'Leads', id: id, select_fields: ['id'])).to be_an_instance_of Hash  }
    end

    context 'with link name to fields array' do
      let(:response) { double('response', body: JSON.generate({"id"=>"6011cc41-31b6-c360-3cf1-5bf55a124a8c", "entry_list"=>{"title"=>{"name"=>"title", "value"=>"Api testing"}}})) }
      let(:conn) { double('http_client', post: response) }
      let(:id) { '6011cc41-31b6-c360-3cf1-5bf55a124a8c' }
      subject { SuiteCrm::Client.new(conn: conn) }

      it { expect(subject.get_entry(module_name: 'Leads', id: id, select_fields: ['id'], link_name_to_fields_array: [
        [
          'name': 'Users',
          'value': ['id']
        ]
      ])).to be_an_instance_of Hash  }
    end
  end

  describe '#conn' do
    subject { SuiteCrm::Client.new(endpoint: 'http://somewhere.com') }
    it { expect(subject.conn).to be_an_instance_of Faraday::Connection }
  end
end
