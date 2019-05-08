RSpec.describe GraphqlPagination::CollectionType do
  describe ".collection_type" do
    let(:type) do
      Class.new(GraphQL::Schema::Object) do
        graphql_name "Fruit"
      end
    end

    subject(:collection_type) { type.collection_type }

    it do
      expect(collection_type.fields.keys).to match_array(%w[collection metadata])
    end
  end
end
