require 'rails_helper'

module ThirdParty
  class Extension < Spree::Base
    # nasty hack so we don't have to create a table to back this fake model
    self.table_name = 'spree_products'
  end
end

RSpec.describe Spree::Product, type: :model do
  let(:shipping_category){
    Spree::ShippingCategory.create(name: "default")
  }

  describe 'apfusion-spree-gem methods' do 
    let(:product){
      Spree::Product.create(name: "testing", 
                            shipping_category: shipping_category, 
                            price: 10.00, 
                            sku: "560-23232-1", 
                            available_on: Time.now)
    }

    describe '#calculate_price' do
      it 'should accept a :price as am argument' do
        allow(product).to receive(:calculate_price).with(200)
      end

      it 'should return the calculated price value price + 0.08' do
        expect(product.send(:calculate_price, 100)).to eq(108)
      end
    end

    describe '#apf_price' do
      it 'should accept a :price as am argument' do
        allow(product).to receive(:apf_price).with(200)
      end
      
      context 'When apfusion_price_level is not empty and greater than 0' do
        it 'Should return apfusion price' do
          product.master.prices.update_all(amount: 10.00, apfusion_price_level: 100.00)
          expect(product.apf_price).to eq(100)
        end
      end

      context 'When apfusion_price_level is empty or less than equal to 0 and resale prices are not empty' do
        it 'Should return resale price' do
          product.master.prices.update_all(amount: 10.00, resale_amount: 170.00)
          expect(product.apf_price).to eq(183.6)
        end
      end

      context 'When apfusion_price_level and resale ampunt is empty or less than equal to 0 and retail prices are not empty' do
        it 'Should return retail price' do
          product.master.prices.update_all(amount: 10.00, resale_amount: 0)
          expect(product.apf_price).to eq(10.8)
        end
      end
    end
  end
end