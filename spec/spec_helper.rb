require 'bundler/setup'
require 'pry'

require 'ostruct'
require 'active_support'
require 'active_support/core_ext'

require 'graphql-pagination'
require 'kaminari/core'

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
    items = (0..10).map { |i| OpenStruct.new(id: SecureRandom.uuid, name: "Mango #{i}") }
    ::Kaminari.paginate_array(items)
  end
end

class VegetableModel
  def self.all
    items = (0..10).map { |i| OpenStruct.new(id: SecureRandom.uuid, name: "Carrot #{i}") }
    ::Kaminari.paginate_array(items)
  end
end

class FruitType < GraphQL::Schema::Object
  field :id, ID, null: false
  field :name, String, null: false
end

class VegetableType < GraphQL::Schema::Object
  field :id, ID, null: false
  field :name, String, null: false
end

class VegetableMetadataType < GraphqlPagination::CollectionMetadataType
  field :custom_field, String, null: false
end

module CustomField
  def custom_field
    "custom_value"
  end
end

class TestQueryType < GraphQL::Schema::Object
  field :fruits, FruitType.collection_type, null: true do
    argument :page, Integer, required: false
    argument :limit, Integer, required: false
  end

  field :vegetables, VegetableType.collection_type(metadata_type: VegetableMetadataType), null: true do
    argument :page, Integer, required: false
    argument :limit, Integer, required: false
  end

  def fruits(page: nil, limit: nil)
    FruitModel.all.page(page).per(limit)
  end

  def vegetables(page: nil, limit: nil)
    results = VegetableModel.all.page(page).per(limit)
    results.extend(CustomField)
    results
  end
end

class TestSchema < GraphQL::Schema
  query TestQueryType
end
