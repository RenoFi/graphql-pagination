require "bundler/setup"
require "pry"
require "graphql-pagination"
require "kaminari/core"

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
end

class FruitModel
  def self.all
    items = (0..10).map { |i| OpenStruct.new(id: SecureRandom.uuid, name: "Apple #{i}") }
    ::Kaminari.paginate_array(items)
  end
end

class FruitType < GraphQL::Schema::Object
  field :id,          ID,     null: false
  field :name,        String, null: false
end

class TestQueryType < GraphQL::Schema::Object
  field :fruits, FruitType.collection_type, null: true do
    argument :page, Integer, required: false
    argument :limit, Integer, required: false
  end

  def fruits(page: nil, limit: nil)
    FruitModel.all.page(page).per(limit)
  end
end

class TestSchema < GraphQL::Schema
  query TestQueryType
end
