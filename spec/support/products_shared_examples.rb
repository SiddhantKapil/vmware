require 'rails_helper'

shared_examples 'filters correctly by parameter' do |parameter_name, parameter_value|
  it "returns products with specified #{parameter_name} only" do
    get '/products', params: {parameter_name => parameter_value}
    
    expect(response.status).to eq(200)
    expect(JSON.parse(response.body)).to eq(expected)
  end
end
