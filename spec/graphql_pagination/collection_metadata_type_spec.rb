RSpec.describe GraphqlPagination::CollectionMetadataType do
  describe '.fields' do
    it do
      expect(described_class.fields.keys).to match_array(%w[currentPage limitValue totalCount totalPages])
    end
  end
end
