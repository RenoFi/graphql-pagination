RSpec.describe GraphqlPagination::CollectionMetadataType do
  describe ".fields" do
    it do
      expect(described_class.fields.keys).to match_array(%w[currentPage limitValue totalCount totalPages])
    end
  end

  describe ".to_graphql" do
    it do
      expect(described_class.to_graphql).to be_a(GraphQL::ObjectType)
      expect(described_class.to_graphql.to_s).to eq("CollectionMetadata")
    end
  end
end
