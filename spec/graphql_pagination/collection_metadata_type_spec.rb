RSpec.describe GraphqlPagination::CollectionMetadataType do
  it 'has description' do
    expect(described_class.description).to be_present
  end

  describe '.fields' do
    it 'has expected fields' do
      expect(described_class.fields.keys).to match_array(%w[currentPage limitValue totalCount totalPages])
    end

    it 'has descriptions on fields' do
      described_class.fields.each do |key, value|
        expect(described_class.fields[key].description).to be_present
      end
    end
  end
end
