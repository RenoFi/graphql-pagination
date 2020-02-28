RSpec.describe 'query spec' do
  subject(:result) { TestSchema.execute(query).to_h['data']['result'] }

  context 'when page and limit given' do
    let(:query) do
      %|{
        result: fruits(page: 2, limit: 2) {
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

  context 'when page and limit not given' do
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

  context "custom metadata type" do
    let(:query) do
      %|{
        result: vegetables {
          collection {
            id
            name
          }
          metadata {
            totalCount
            totalPages
            limitValue
            currentPage
            customField
          }
        }
      }|
    end

    it do
      result = TestSchema.execute(query).to_h["data"]["result"]
      # binding.pry
      expect(result["collection"].size).to eq(11)
      expect(result["collection"][0]["id"]).not_to be_empty
      expect(result["collection"][0]["name"]).not_to be_empty
      expect(result["metadata"]["totalCount"]).to eq(11)
      expect(result["metadata"]["totalPages"]).to eq(1)
      expect(result["metadata"]["limitValue"]).to eq(25)
      expect(result["metadata"]["currentPage"]).to eq(1)
      expect(result["metadata"]["customField"]).to eq("custom_value")
    end
  end
end
