RSpec.describe GraphqlPagination::PaginatedField do
  describe '.paginated_field' do
    let(:query_type) do
      Class.new(GraphQL::Schema::Object) do
        graphql_name 'TestQuery'

        paginated_field :fruits, FruitType.collection_type, null: true

        paginated_field :vegetables, VegetableType.collection_type, null: true do
          argument :where, String, required: false
          argument :order, String, required: false
        end

        def fruits(page: nil, per: nil)
          FruitModel.all.page(page).per(per)
        end

        def vegetables(page: nil, per: nil, **)
          VegetableModel.all.page(page).per(per)
        end
      end
    end

    let(:schema) do
      query = query_type
      Class.new(GraphQL::Schema) do
        query query
      end
    end

    it 'defines field with pagination arguments' do
      field = query_type.fields['fruits']
      expect(field).not_to be_nil
      expect(field.arguments.keys).to include('page', 'per')
    end

    it 'page argument is optional' do
      field = query_type.fields['fruits']
      expect(field.arguments['page'].type.non_null?).to be false
    end

    it 'per argument is optional' do
      field = query_type.fields['fruits']
      expect(field.arguments['per'].type.non_null?).to be false
    end

    context 'with additional arguments in block' do
      it 'includes additional arguments' do
        field = query_type.fields['vegetables']
        expect(field.arguments.keys).to include('page', 'per', 'where', 'order')
      end

      it 'additional arguments are optional' do
        field = query_type.fields['vegetables']
        expect(field.arguments['where'].type.non_null?).to be false
        expect(field.arguments['order'].type.non_null?).to be false
      end
    end

    context 'when used in queries' do
      subject(:result) { schema.execute(query).to_h['data']['result'] }

      context 'with page and per arguments' do
        let(:query) do
          %|{
            result: fruits(page: 2, per: 2) {
              collection {
                id
                name
              }
              metadata {
                totalCount
                totalPages
                limitValue
                currentPage
              }
            }
          }|
        end

        it 'executes query successfully' do
          expect(result['collection'].size).to eq(2)
          expect(result['metadata']['currentPage']).to eq(2)
          expect(result['metadata']['limitValue']).to eq(2)
        end
      end

      context 'without page and per arguments' do
        let(:query) do
          %|{
            result: fruits {
              collection {
                id
                name
              }
              metadata {
                totalCount
                totalPages
                limitValue
                currentPage
              }
            }
          }|
        end

        it 'executes query successfully' do
          expect(result['collection'].size).to eq(11)
          expect(result['metadata']['currentPage']).to eq(1)
        end
      end

      context 'with additional arguments' do
        let(:query) do
          %|{
            result: vegetables(page: 1, per: 5, where: "test") {
              collection {
                id
                name
              }
              metadata {
                totalCount
              }
            }
          }|
        end

        it 'executes query successfully with additional arguments' do
          expect(result['collection'].size).to eq(5)
          expect(result['metadata']['totalCount']).to eq(11)
        end
      end
    end
  end
end
