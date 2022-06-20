require 'spec_helper'

RSpec.describe SpreeApfusion::Product do

  let(:shipping_category) {
    Spree::ShippingCategory.create(name: "default")
  }

  describe '.generate_product_hash' do 
     let(:product){
        Spree::Product.create(name: "testing", 
                              shipping_category: shipping_category, 
                              price: 10.00, 
                              sku: "560-23232", 
                              available_on: Time.now)
      }
      context 'when apfusion_price_level is not empty and greater than 0' do
        it 'should return a hash with product attributes with correct apfusion price' do
          product.master.prices.update_all(amount: 10.00, apfusion_price_level: 100.00)
          product_hash = described_class.generate_product_hash(product)
          expect(product_hash).to be_kind_of Hash
          expect(product_hash['price'].to_i).to eq 100
        end
      end

      context 'when apfusion_price_level is empty or less than or equal 0' do
        it 'should return a hash with product attributes with correct apfusion price' do
          product.master.prices.update_all(amount: 10.00, apfusion_price_level: 0)
          product_hash = described_class.generate_product_hash(product)
          expect(product_hash).to be_kind_of Hash
          expect(product_hash['price'].to_f).to eq (10.8)

           product.master.prices.update_all(amount: 10.00, apfusion_price_level: nil)
          product_hash = described_class.generate_product_hash(product)
          expect(product_hash).to be_kind_of Hash
          expect(product_hash['price'].to_f).to eq (10.8)
        end

        it 'should return an empty hash when product is nil' do
          product_hash = described_class.generate_product_hash(nil)
          expect(product_hash).to be_kind_of Hash
          expect(product_hash).to be_empty
        end
      end

  end

end