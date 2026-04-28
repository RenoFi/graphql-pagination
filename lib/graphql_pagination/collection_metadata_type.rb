module GraphqlPagination
  class CollectionMetadataType < GraphQL::Schema::Object
    if defined?(ApolloFederation::Object) && defined?(Reconf) &&
        Gem::Version.new(Reconf.fetch("renoql.federation_version") { "1.0" }.to_s) >= Gem::Version.new("2.0.0")
      include ApolloFederation::Object

      shareable
    end

    description "Type for CollectionMetadataType"
    field :current_page, Integer, null: false, description: "Current Page of loaded data"
    field :limit_value, Integer, null: false, description: "The number of items per page"
    field :total_count, Integer, null: false, description: "The total number of items to be paginated"
    field :total_pages, Integer, null: false, description: "The total number of pages in the pagination"
  end
end
