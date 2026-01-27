module GraphqlPagination
  module PaginatedField
    def paginated_field(name, type, **kwargs, &block)
      field name, type, **kwargs do
        argument :page, Integer, required: false
        argument :per, Integer, required: false
        instance_eval(&block) if block_given?
      end
    end
  end
end
