module GraphqlPagination
  class CollectionBaseError < StandardError
    def message
      "CollectionBaseError: The collection_type attribute must inherit from
      or be a GraphQL::Schema::Object"
    end
  end
end
