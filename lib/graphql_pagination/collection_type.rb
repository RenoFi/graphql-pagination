module GraphqlPagination
  module CollectionType
    def collection_type(
      collection_base: GraphQL::Schema::Object,
      metadata_type: GraphqlPagination::CollectionMetadataType
    )
      fail CollectionBaseError unless collection_base <= GraphQL::Schema::Object

      @collection_types ||= {}
      @collection_types[collection_base] ||= {}
      @collection_types[collection_base][metadata_type] ||= begin
        type_name = "#{graphql_name}Collection"
        source_type = self

        Class.new(collection_base) do
          graphql_name type_name
          description "#{graphql_name} type"
          field :collection, [source_type], null: false, description: "A collection of paginated #{graphql_name}"
          field :metadata, metadata_type, null: false, description: "Pagination Metadata for navigating the Pagination"

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
