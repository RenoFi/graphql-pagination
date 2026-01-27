[![Gem Version](https://badge.fury.io/rb/graphql-pagination.svg)](https://rubygems.org/gems/graphql-pagination)
[![Build Status](https://github.com/RenoFi/graphql-pagination/actions/workflows/ci.yml/badge.svg)](https://github.com/RenoFi/graphql-pagination/actions/workflows/ci.yml?query=branch%3Amain)

# graphql-pagination

Implements page-based pagination returning collection and pagination metadata. It works with `kaminari` or other pagination tools implementing similar methods.

## Installation

Add `graphql-pagination` to your Gemfile, you can use `kaminari-activerecord` or `kaminari-monogid` to not implement page scope methods. Kaminari is not loaded by the gem, so you need to decide and load it on your own.

```ruby
  gem 'graphql-pagination'
  gem 'kaminari-activerecord'
```

## Usage example

### With Fields

Use `collection_type` instead of `connection_type` to define your type:

```ruby
  field :fruits, Types::FruitType.collection_type, null: true do
    argument :page, Integer, required: false
    argument :limit, Integer, required: false
  end

  def fruits(page: nil, limit: nil)
    ::Fruit.page(page).per(limit)
  end
```

### With Resolvers

You can also use `collection_type` with GraphQL resolvers:

```ruby
module Resolvers
  class FruitsResolver < GraphQL::Schema::Resolver
    type Types::FruitType.collection_type, null: false

    argument :page, Integer, required: false
    argument :limit, Integer, required: false

    def resolve(page: nil, limit: nil)
      ::Fruit.page(page).per(limit)
    end
  end
end

# In your query type
field :fruits, resolver: Resolvers::FruitsResolver
```

Value returned by query resolver must be a kaminari object or implements its page scope methods (`current_page`, `limit_value`, `total_count`, `total_pages`).

## GraphQL query

```graphql
{
  fruits(page: 2, limit: 2) {
    collection {
      id
      name
    }
    metadata {
      totalPages
      totalCount
      currentPage
      limitValue
    }
  }
}
```

```json
{
  "data": {
    "checklists": {
      "collection": [
        {
          "id": "93938bb3-7a6c-4d35-9961-cbb2d4c9e9ac",
          "name": "Apple"
        },
        {
          "id": "b1ee93b2-579a-4107-8454-119bba5afb63",
          "name": "Mango"
        }
      ],
      "metadata": {
        "totalPages": 25,
        "totalCount": 50,
        "currentPage": 2,
        "limitValue": 2
      }
    }
  }
}
```

## Custom Base

By default the resulting collection_type class is a direct descendant of
graphql-ruby's GraphQL::Schema::Object, however you may require your own
behaviours and properties on the collection class itself such as defining
[custom visibility](https://graphql-ruby.org/authorization/visibility.html#object-visibility).

This can be done by passing in your own custom class, to be inherited from:

```ruby
class MyBaseType < GraphQL::Schema::Object
  def self.visible?(context)
    # ...
  end
end

field :fruits, Types::FruitType.collection_type(collection_base: MyBaseType)
```

## Custom Metadata

By default, the following fields are present in the metadata block:

```graphql
metadata {
  totalPages
  totalCount
  currentPage
  limitValue
}
```

These fields correspond to the `GraphqlPagination::CollectionMetadataType` used to provide the pagination information for the collection of data delivered. If you want to add more metadata fields to this block, you can do so by extending this `CollectionMetadataType`:

```ruby
class MyMetadataType < GraphqlPagination::CollectionMetadataType
  field :custom_field, String, null: false
end

field :fruits, Types::FruitType.collection_type(metadata_type: MyMetadataType)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/renofi/graphql-pagination. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
