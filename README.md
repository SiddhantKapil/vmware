# Ruby on Rails: Data Import from CSV

## Project Specifications

**Read-Only Files**
- spec/*

**Environment**  

- Ruby version: 2.7.1
- Rails version: 6.0.2
- Default Port: 8000

**Commands**
- run: 
```bash
bin/bundle exec rails server --binding 0.0.0.0 --port 8000
```
- install: 
```bash
bin/env_setup && source ~/.rvm/scripts/rvm && rvm --default use 2.7.1 && bin/bundle install
```
- test: 
```bash
RAILS_ENV=test bin/rails db:migrate && RAILS_ENV=test bin/bundle exec rspec
```
    
## Question description

In this challenge, you are part of a team that is building an eCommerce platform. One requirement is for a REST API service to import product information using the Ruby on Rails framework. You will need to add functionality to import products from an CSV file as well as list all products in the system. The team has come up with a set of requirements including API format, response codes, and structure for the queries you must implement.

The definitions and a detailed requirements list follow. You will be graded on whether your application performs data persistence and retrieval based on given use cases exactly as described in the requirements.

Each product has the following structure:

* id: The unique ID of the product (Integer)
* name: The name of the product (String)
* description: The description of the product (String)
* price: The price of the product (BigDecimal)
* primary_category: The name of the primary category of the product (String)
* seconday_category: The name of the secondary category of the product (String)
* model_number: The model number (String)
* upc: The universal product code (String)
* sku: The stock keeping unit (String)


### Sample product JSON:

```
{
  "id": 1,
  "name": "Carpet",
  "description": "Grey woven carpet",
  "sku": "8857425127",
  "price": "290.99",
  "primary_category": "Living room",
  "model_number": "15590",
  "seconday_category": "Textile",
  "upc": "123143"
}
```

### CSV file format:

| Item Number/SKU | UPC    | Item Name     | Item Description | Price  | Style/Model-Number/Name | Primary Category | Sub-Category |
|-----------------|--------|---------------|------------------|--------|-------------------------|------------------|--------------|
| 8857425124      | 123140 | Frilly Pillow | Synthetic        | 19.99  | 15587                   | Living room      | Textile      |
| 001-74227       | 123143 | Carpet        | Polyester        | 290.99 | M-590X                  | Apartment        | Textile      |
|...|


You can see a sample file [at this link.](spec/fixtures/products-1.csv)

## Requirements:

You are provided with the implementation of the Product model. The REST service must expose the `/products` endpoint, which allows for managing the collection of products in the following way:

`POST /products`:

- accepts a CSV file as input parameter:
  ```
  {
    "file": <UploadedFile name="products.csv">
  }
  ```
- validates that the file is present
- if the file is not provided, returns status code 422
- if the file is provided, for every record from the CSV file, it creates a correspondent product in the database. You can assume that all the data in the file is valid.
- the response code is 201, and the response body is the list of created products in JSON format, including their unique ids


`GET /products`

- returns a JSON of the collection of all products, ordered by id in increasing order
- returns response code 200
- accepts the optional query parameter `name`. If `name` is present, returns all products with the given name.
- accepts the optional query parameter `primary_category`. If `primary_category` is present, returns all products with the given primary category.
- accepts the optional query parameter `model_number`. If `model_number` is present, returns all products with the model number.
- accepts the optional query parameter `upc`. If `upc` is present, returns all products with the given UPC.
- accepts the optional query parameter `sku`. If `sku` is present, returns all products with the given SKU.


## Example requests and responsess

`POST /products`

Request:

```
{
  "file": <UploadedFile name="products.csv">
}
```

The response code is 201, and when converted to JSON, the response body is:

```
[
  {
    "id": 1,
    "name": "Frilly Pillow",
    "description": "Synthetic",
    "sku": "8857425124",
    "price": "19.99",
    "primary_category": "Living room",
    "model_number": "15587",
    "seconday_category": "Textile",
    "upc": "123140"
  },
  {
    "id": 2,
    "name": "Carpet",
    "description": "Polyester",
    "sku": "001-74227",
    "price": "290.99",
    "primary_category": "Apartment",
    "model_number": "M-590X",
    "seconday_category": "Textile",
    "upc": "123143"
  }
]
```

This adds new objects to the collection and assigns unique ids.

`GET /products`

Response:

```
[
  {
    "id": 1,
    "name": "Frilly Pillow",
    "description": "Synthetic",
    "sku": "8857425124",
    "price": "19.99",
    "primary_category": "Living room",
    "model_number": "15587",
    "seconday_category": "Textile",
    "upc": "123140"
  },
  {
    "id": 2,
    "name": "Carpet",
    "description": "Polyester",
    "sku": "001-74227",
    "price": "290.99",
    "primary_category": "Apartment",
    "model_number": "M-590X",
    "seconday_category": "Textile",
    "upc": "123143"
  }
]
```

`GET /products?name=Carpet`

Response:

```
[
  {
    "id": 2,
    "name": "Carpet",
    "description": "Polyester",
    "sku": "001-74227",
    "price": "290.99",
    "primary_category": "Apartment",
    "model_number": "M-590X",
    "seconday_category": "Textile",
    "upc": "123143"
  }
]
```

`GET /products?sku=8857425124`

Response:

```
[
  {
    "id": 1,
    "name": "Frilly Pillow",
    "description": "Synthetic",
    "sku": "8857425124",
    "price": "19.99",
    "primary_category": "Living room",
    "model_number": "15587",
    "seconday_category": "Textile",
    "upc": "123140"
  }
]
```

`GET /products?upc=123143`

Response:

```
[
  {
    "id": 2,
    "name": "Carpet",
    "description": "Polyester",
    "sku": "001-74227",
    "price": "290.99",
    "primary_category": "Apartment",
    "model_number": "M-590X",
    "seconday_category": "Textile",
    "upc": "123143"
  }
]
```

`GET /products?primary_category=Apartment`

Response:

```
[
  {
    "id": 2,
    "name": "Carpet",
    "description": "Polyester",
    "sku": "001-74227",
    "price": "290.99",
    "primary_category": "Apartment",
    "model_number": "M-590X",
    "seconday_category": "Textile",
    "upc": "123143"
  }
]
```

`GET /products?model_number=15587`

Response:

```
[
  {
    "id": 1,
    "name": "Frilly Pillow",
    "description": "Synthetic",
    "sku": "8857425124",
    "price": "19.99",
    "primary_category": "Living room",
    "model_number": "15587",
    "seconday_category": "Textile",
    "upc": "123140"
  }
]
```
