RSpec.describe GraphqlPagination::CollectionType do
  describe ".collection_type" do
    subject(:collection_type) { type.collection_type }

    let(:type) do
      Class.new(GraphQL::Schema::Object) do
        graphql_name "Fruit"
      end
    end

    it "has expected fields" do
      expect(collection_type.fields.keys).to match_array(%w[collection metadata])
    end

    it "has description" do
      expect(collection_type.description).to be_present
    end

    context "with custom metadata type" do
      let(:collection_type) { type.collection_type }
      let(:custom_collection_type) { type.collection_type(metadata_type:) }

      let(:metadata_type) do
        Class.new(GraphqlPagination::CollectionMetadataType) do
          graphql_name "CustomCollectionMetadataType"
          field :foo, String, null: true
        end
      end

      it "returns an appropriate collection type based on metadata_type argument" do
        expect(collection_type.fields["metadata"].type.of_type.fields.keys).not_to include("foo")
        expect(custom_collection_type.fields["metadata"].type.of_type.fields.keys).to include("foo")
      end

      it "caches the type for future use" do
        expect(custom_collection_type).to be(type.collection_type(metadata_type:))
      end

      it "has description" do
        expect(custom_collection_type.fields["metadata"].description).to be_present
      end
    end

    context "with custom collection base" do
      let(:collection_base) do
        Class.new(GraphQL::Schema::Object) do
          graphql_name "CustomCollectionBase"
          field :foo, String, null: true
          def self.visible?(_) = false
        end
      end

      let(:collection_type) { type.collection_type }
      let(:custom_collection_type) { type.collection_type(collection_base:) }

      it "returns an appropriate collection type based on collection_base argument" do
        expect(collection_type.visible?(nil)).to be true
        expect(custom_collection_type.visible?(nil)).to be false

        expect(collection_type.fields.keys).not_to include("foo")
        expect(custom_collection_type.fields.keys).to include("foo")
      end

      it "has description" do
        expect(custom_collection_type.fields["collection"].description).to be_present
      end

      it "caches the type for future use" do
        expect(custom_collection_type).to be(type.collection_type(collection_base:))
      end

      context "when collection_base is not a GraphQL::Schema::Object" do
        let(:collection_base) { Class.new }

        it "raises an error" do
          expect { custom_collection_type }.to raise_error(GraphqlPagination::CollectionBaseError)
        end
      end
    end
  end
end
