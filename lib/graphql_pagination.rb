require 'graphql_pagination/version'
require 'graphql'
require 'graphql/schema'

module GraphqlPagination
end

require 'graphql_pagination/collection_base_error'
require 'graphql_pagination/collection_type'
require 'graphql_pagination/collection_metadata_type'
require 'graphql_pagination/collection_field'
require 'graphql_pagination/paginated_field'

GraphQL::Schema::Object.extend GraphqlPagination::CollectionType
GraphQL::Schema::Object.extend GraphqlPagination::PaginatedField
GraphQL::Schema::Resolver.extend GraphqlPagination::CollectionType
