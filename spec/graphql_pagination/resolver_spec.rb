RSpec.describe 'resolver spec' do
  subject(:result) { TestSchema.execute(query).to_h['data']['result'] }

  context 'with resolver using collection_type' do
    let(:query) do
      %|{
        result: berriesResolver(page: 2, limit: 2) {
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

    it do
      expect(result['collection'].size).to eq(2)
      expect(result['collection'][0]['id']).not_to be_empty
      expect(result['collection'][0]['name']).not_to be_empty
      expect(result['metadata']['totalCount']).to eq(11)
      expect(result['metadata']['totalPages']).to eq(6)
      expect(result['metadata']['limitValue']).to eq(2)
      expect(result['metadata']['currentPage']).to eq(2)
    end
  end

  context 'with resolver using collection_type without page and limit' do
    let(:query) do
      %|{
        result: berriesResolver {
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

    it do
      expect(result['collection'].size).to eq(11)
      expect(result['collection'][0]['id']).not_to be_empty
      expect(result['collection'][0]['name']).not_to be_empty
      expect(result['metadata']['totalCount']).to eq(11)
      expect(result['metadata']['totalPages']).to eq(1)
      expect(result['metadata']['limitValue']).to eq(25)
      expect(result['metadata']['currentPage']).to eq(1)
    end
  end

  describe 'schema introspection' do
    it 'includes collection and metadata fields in resolver type' do
      schema_definition = TestSchema.to_definition

      expect(schema_definition).to include('berriesResolver')
      expect(schema_definition).to include('BerryCollection')
      expect(schema_definition).to include('collection: [Berry!]!')
      expect(schema_definition).to include('metadata: CollectionMetadata!')
      expect(schema_definition).not_to include('PageInfo')
      expect(schema_definition).not_to include('edges')
      expect(schema_definition).not_to include('nodes')
    end
  end
end
