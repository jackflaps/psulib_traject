# frozen_string_literal: true

RSpec::Matchers.define_negated_matcher :not_include, :include

RSpec.describe 'Psulib_config spec:' do
  let(:leader) { '1234567890' }

  before(:all) do
    c = './lib/traject/psulib_config.rb'
    @indexer = Traject::Indexer.new
    @indexer.load_config_file(c)
  end

  describe 'Record with music numeric should have semicolons for all but subfield e' do
    let(:field) { 'music_numerical_ssm' }
    let(:music_383) do
      { '383' => { 'ind1' => '1', 'ind2' => '0', 'subfields' => [{ 'b' => 'op. 36' },
                                                                 { 'b' => 'op. 86' },
                                                                 { 'b' => 'op. 35' },
                                                                 { 'e' => 'Bach' },
                                                                 { 'e' => 'Motzart' }] } }
    end
    let(:result) { @indexer.map_record(MARC::Record.new_from_hash('fields' => [music_383], 'leader' => leader)) }

    it 'has some semi colons' do
      expect(result[field]).to eq ['op. 36; op. 86; op. 35', 'Bach', 'Motzart']
    end
  end
end