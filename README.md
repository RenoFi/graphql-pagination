# graphql-pagination

### Implements page-based pagination returning collection and pagination metadata. 

## Usage example

Add `graphql-pagination` to your Gemfile, you can use `kaminari-activerecord` or `kaminari-monogid` to not implement page scope methods. It's not loaded by the gem, so you need to decide on your own.

```ruby
  gem 'graphql-pagination'
  gem 'kaminari-activerecord'
```

```ruby
  field :foods, Types::FoodType.collection_type, null: true do
    argument :page, Integer, required: false
    argument :limit, Integer, required: false
  end
  
  def foods(page: nil, limit: nil)
    ::Food.page(page).per(limit)
  end
```

Value returned by query resolver must be a kaminari object or implements its page scope methods (`current_page`, `limit_value`, `total_count`, `total_pages`).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/renofi/graphql-pagination. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

