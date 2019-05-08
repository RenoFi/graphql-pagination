
[![Gem Version](https://badge.fury.io/rb/graphql-pagination.png)][gem_version]

[gem_version]: https://rubygems.org/gems/a9n

# graphql-pagination

Implements page-based pagination returning collection and pagination metadata. It works with `kaminari` or other pagination tools implementing similar methods.

## Installation

Add `graphql-pagination` to your Gemfile, you can use `kaminari-activerecord` or `kaminari-monogid` to not implement page scope methods. Kaminari is not loaded by the gem, so you need to decide anmd load it on your own.

```ruby
  gem 'graphql-pagination'
  gem 'kaminari-activerecord'
```

## Usage example

```ruby
  field :fruits, Types::FruitType.collection_type, null: true do
    argument :page, Integer, required: false
    argument :limit, Integer, required: false
  end

  def fruit(page: nil, limit: nil)
    ::Fruit.page(page).per(limit)
  end
```

Value returned by query resolver must be a kaminari object or implements its page scope methods (`current_page`, `limit_value`, `total_count`, `total_pages`).


## GraphQL query

```
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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/renofi/graphql-pagination. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

