RSpec.describe GraphqlPagination::CollectionType do
  describe '.collection_type' do
    subject(:collection_type) { type.collection_type }

    let(:type) do
      Class.new(GraphQL::Schema::Object) do
        graphql_name 'Fruit'
      end
    end

    it do
      expect(collection_type.fields.keys).to match_array(%w[collection metadata])
    end

    context "with custom metadata type" do
      let(:collection_type) { type.collection_type }
      let(:custom_collection_type) { type.collection_type(metadata_type: metadata_type) }

      let(:metadata_type) do
        Class.new(GraphqlPagination::CollectionMetadataType) do
          graphql_name 'CustomCollectionMetadataType'
          field :foo, String, null: true
        end
      end

      it "returns an appropriate collection type based on metadata_type argument" do
        expect(collection_type.fields['metadata'].type.of_type.fields.keys).not_to include('foo')
        expect(custom_collection_type.fields['metadata'].type.of_type.fields.keys).to include('foo')
      end

      it "caches the type for future use" do
        expect(custom_collection_type).to be(type.collection_type(metadata_type: metadata_type))
      end
    end
  end
end
