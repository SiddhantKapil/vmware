require 'rails_helper'

describe 'ProductsController', type: :request do
  let(:products_file_data) do
    [
      {
        name: 'Frilly Pillow',
        description: 'Synthetic',
        sku: '8857425124',
        price: '19.99',
        primary_category: 'Living room',
        model_number: '15587',
        seconday_category: 'Textile',
        upc: '123140'
      },
      {
        name: 'Carpet',
        description: 'Polyester',
        sku: '001-74227',
        price: '290.99',
        primary_category: 'Apartment',
        model_number: 'M-590X',
        seconday_category: 'Textile',
        upc: '123143'
      }
    ]
  end

  let(:persisted_products_file_data) do
    products_file_data.each.with_index(1) do |product, index|
      product[:id] = index
    end.map(&:stringify_keys)
  end

  describe 'POST /products' do
    let(:products_file) { fixture_file_upload('products-1.csv') }
    let(:params) { { file: products_file } }

    context 'when "file" parameter is present' do
      it 'returns response status 201' do
        post '/products', params: params
        expect(response.status).to eq(201)
      end

      it 'returns all products from the file with their corresponding IDs' do
        post '/products', params: params
        expect(JSON.parse(response.body)).to eq(persisted_products_file_data)
      end

      it 'persists products to database' do
        post '/products', params: params
        get '/products'
        fail('Cannot access /products endpoint') unless response.status == 200

        expect(JSON.parse(response.body)).to eq(persisted_products_file_data)
      end
    end

    context 'when "file" parameter is missing' do
      let(:products_file) { nil }

      it 'returns response status 422' do
        post '/products', params: params
        expect(response.status).to eq(422)
      end
    end

    context 'when there are already some products in the system' do
      it 'returns only products, which have been imported with a given file' do
        post '/products', params: { file: fixture_file_upload('products-1.csv') }
        expect(response.status).to eq(201)
        last_id = JSON.parse(response.body)[-1]['id'] 
        
        post '/products', params: { file: fixture_file_upload('products-2.csv') }
        expect(response.status).to eq(201)

        expected = [
          {
            id: last_id + 1,
            name: 'Vase',
            description: 'Color: red',
            sku: '8857422002',
            price: '40.99',
            primary_category: 'Living room',
            model_number: '15523',
            seconday_category: 'Home decor',
            upc: '98765'
          }
        ].map(&:stringify_keys)
        expect(JSON.parse(response.body)).to eq(expected)
      end
    end
  end

  describe 'GET /products' do
    context 'when system does not contain any products' do
      it 'returns empty array' do
        get '/products'

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when there are products in the system' do
      before do
        post '/products', params: {file: fixture_file_upload('products-1.csv')}
      end

      it 'returns all products information in JSON format ordered by ID' do
        get '/products'
        expect(JSON.parse(response.body)).to eq(persisted_products_file_data)
      end

      context 'when "name" parameter is present' do
        let(:expected) { [persisted_products_file_data[0]] }
        include_examples 'filters correctly by parameter', :name, 'Frilly Pillow'
      end

      context 'when "sku" parameter is present' do
        let(:expected) { [persisted_products_file_data[1]] }
        include_examples 'filters correctly by parameter', :sku, '001-74227'
      end

      context 'when "primary_category" parameter is present' do
        let(:expected) { [persisted_products_file_data[0]] }
        include_examples 'filters correctly by parameter', :primary_category, 'Living room'
      end

      context 'when "model_number" parameter is present' do
        let(:expected) { [persisted_products_file_data[1]] }
        include_examples 'filters correctly by parameter', :model_number, 'M-590X'
      end

      context 'when "upc" parameter is present' do
        let(:expected) { [persisted_products_file_data[0]] }
        include_examples 'filters correctly by parameter', :upc, '123140'
      end
    end
  end
end

