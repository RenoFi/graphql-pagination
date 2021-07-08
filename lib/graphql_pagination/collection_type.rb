module GraphqlPagination
  module CollectionType
    def collection_type(metadata_type: GraphqlPagination::CollectionMetadataType)
      @collection_types ||= {}
      @collection_types[metadata_type] ||= begin
        type_name = "#{graphql_name}Collection"
        source_type = self

        Class.new(GraphQL::Schema::Object) do
          graphql_name type_name
          field :collection, [source_type], null: false
          field :metadata, metadata_type, null: false

          def collection
            object
          end

          def metadata
            object
          end
        end
      end
    end
  end
end
