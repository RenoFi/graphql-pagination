module GraphqlPagination
  module PaginatedField
    def paginated_field(name, type, **, &)
      field(name, type, **) do
        argument :page, Integer, required: false
        argument :per, Integer, required: false
        instance_eval(&) if block_given?
      end
    end
  end
end
