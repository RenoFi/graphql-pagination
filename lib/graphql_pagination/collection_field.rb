module GraphqlPagination
  module CollectionField
    # Check if the field returns a collection type
    def collection_type?
      if @return_type_expr&.respond_to?(:graphql_name)
        @return_type_expr.graphql_name.end_with?('Collection')
      else
        false
      end
    end

    # Calculate complexity for collection fields
    # This is based on graphql-ruby's connection complexity calculation
    # See: https://github.com/rmosolgo/graphql-ruby/blob/master/lib/graphql/schema/field.rb#L472
    def calculate_complexity(query:, nodes:, child_complexity:)
      if collection_type?
        arguments = query.arguments_for(nodes.first, self)
        
        # Get the page size from the `limit` or `per` argument
        # Default to a reasonable value if not provided
        max_possible_page_size = arguments[:limit] || arguments[:per]
        
        if max_possible_page_size.nil?
          # Use schema defaults or a reasonable default
          max_possible_page_size = default_page_size || 
                                   query.schema.default_page_size || 
                                   max_page_size || 
                                   query.schema.default_max_page_size || 
                                   25 # Reasonable default for kaminari
        end

        metadata_complexity = 0
        lookahead = GraphQL::Execution::Lookahead.new(query: query, field: self, ast_nodes: nodes, owner_type: owner)

        # Calculate metadata complexity
        if (metadata_lookahead = lookahead.selection(:metadata)).selected?
          metadata_complexity += 1 # metadata field itself
          metadata_complexity += metadata_lookahead.selections.size # metadata subfields
        end

        # Check for total_pages and total_count (they are part of metadata)
        # Note: These are already counted above if metadata is selected

        nodes_edges_complexity = 0
        nodes_edges_complexity += 1 if lookahead.selects?(:collection)

        # Calculate items complexity
        # Subtract metadata and collection field complexity from child complexity
        items_complexity = child_complexity - metadata_complexity - nodes_edges_complexity
        
        # Apply complexity: 1 (this field) + (page_size * items) + metadata + collection
        1 + (max_possible_page_size * items_complexity) + metadata_complexity + nodes_edges_complexity
      else
        super
      end
    end
  end
end
