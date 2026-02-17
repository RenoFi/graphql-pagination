# Complexity Calculation Example
#
# This example demonstrates how to use the CollectionField module
# to automatically calculate complexity for collection type fields.

require "bundler/setup"
require "graphql-pagination"
require "kaminari/core"

# Sample data model
class User
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def self.all
    users = (1..100).map { |i| User.new(i, "User #{i}") }
    Kaminari.paginate_array(users)
  end
end

# GraphQL Types
class UserType < GraphQL::Schema::Object
  field :id, ID, null: false
  field :name, String, null: false
end

# Base field with complexity calculation
class BaseField < GraphQL::Schema::Field
  prepend GraphqlPagination::CollectionField
end

class BaseObject < GraphQL::Schema::Object
  field_class BaseField
end

class QueryType < BaseObject
  field :users, UserType.collection_type, null: false do
    argument :page, Integer, required: false
    argument :limit, Integer, required: false
  end

  def users(page: nil, limit: nil)
    User.all.page(page).per(limit)
  end
end

class ExampleSchema < GraphQL::Schema
  query QueryType
  max_complexity 500
end

# Example queries
simple_query = <<~GRAPHQL
  {
    users(limit: 5) {
      collection {
        id
        name
      }
      metadata {
        currentPage
        totalPages
      }
    }
  }
GRAPHQL

complex_query = <<~GRAPHQL
  {
    users(limit: 50) {
      collection {
        id
        name
      }
      metadata {
        currentPage
        totalPages
        totalCount
        limitValue
      }
    }
  }
GRAPHQL

puts "Example 1: Simple query with limit: 5"
puts "=" * 50
result = ExampleSchema.execute(simple_query)
if result["errors"]
  puts "Errors: #{result["errors"]}"
else
  puts "Success! Retrieved #{result["data"]["users"]["collection"].size} users"
  puts "Current Page: #{result["data"]["users"]["metadata"]["currentPage"]}"
  puts "Total Pages: #{result["data"]["users"]["metadata"]["totalPages"]}"
end

puts "\n"
puts "Example 2: Complex query with limit: 50"
puts "=" * 50
result = ExampleSchema.execute(complex_query)
if result["errors"]
  puts "Errors: #{result["errors"]}"
else
  puts "Success! Retrieved #{result["data"]["users"]["collection"].size} users"
  puts "Current Page: #{result["data"]["users"]["metadata"]["currentPage"]}"
  puts "Total Pages: #{result["data"]["users"]["metadata"]["totalPages"]}"
  puts "Total Count: #{result["data"]["users"]["metadata"]["totalCount"]}"
  puts "Limit Value: #{result["data"]["users"]["metadata"]["limitValue"]}"
end

puts "\n"
puts "Note: With the CollectionField module, complexity is automatically calculated"
puts "based on the limit argument, preventing queries from loading too much data."
