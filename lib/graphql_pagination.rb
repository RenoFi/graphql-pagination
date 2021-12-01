require 'graphql_pagination/version'
require 'graphql'
require 'graphql/schema/object'

module GraphqlPagination
end

require 'graphql_pagination/collection_type'
require 'graphql_pagination/collection_metadata_type'

GraphQL::Schema::Object.extend GraphqlPagination::CollectionType
GraphQL::Schema::Union.extend GraphqlPagination::CollectionType
