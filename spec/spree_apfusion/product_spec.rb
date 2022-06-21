require 'spec_helper'

RSpec.describe SpreeApfusion::Product do

  let(:shipping_category) {
    Spree::ShippingCategory.create(name: "default")
  }

  let(:product){
      Spree::Product.create(name: "testing", 
                            shipping_category: shipping_category, 
                            price: 10.00, 
                            sku: "560-23232", 
                            available_on: Time.now)
    }

  describe '.generate_product_hash' do 
    it 'should accept a :product object as a parameter' do
      allow(described_class).to receive(:generate_product_hash).with(product)
    end

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

  describe '.add_product_price' do
    it 'should accept a :product object as a parameter' do
      allow(described_class).to receive(:add_product_price).with(product)
    end

    it 'should set price, resale_amount and bsap_amount' do
      product.master.prices.update_all(amount: 10.00, apfusion_price_level: 100.00, resale_amount: 95, bsap_amount: 92)
      described_class.generate_product_hash(product)
      product_hash = described_class.add_product_price(product)
      expect(product_hash['price'].to_i).to eq(100)
      expect(product_hash['resale_amount'].to_i).to eq(95)
      expect(product_hash['bsap_amount'].to_f).to eq(100.28) # 92 + 92 * 0.09
    end

    it 'should return the retail amount when bsap amount is nil' do
      product.master.prices.update_all(amount: 11.00, bsap_amount: nil)
      described_class.generate_product_hash(product)
      product_hash = described_class.add_product_price(product)
      expect(product_hash['bsap_amount'].to_f).to eq(11.99)
    end
  end

  describe '.add_option_type_id' do
    it 'should accept a :product object as a parameter' do
      allow(described_class).to receive(:add_option_type_id).with(product)
    end

    it "Should return option_type_ids" do
      described_class.generate_product_hash(product)
      product_hash = described_class.add_option_type_id(product)
      expect(described_class.add_option_type_id(product)).to be_kind_of Array
    end
  end

  describe '.add_sku' do
    it 'should accept a :product object as a parameter' do
      allow(described_class).to receive(:add_sku).with(product)
    end

    it "Should return sku" do
      described_class.generate_product_hash(product)
      product_hash = described_class.add_sku(product)
      expect(described_class.add_sku(product)).to eq('560-23232-1')
    end
  end

  describe '.add_taxons' do
    it 'should accept a :product object as a parameter' do
      allow(described_class).to receive(:add_taxons).with(product)
    end

    it "Should return taxon_ids 5" do
      described_class.generate_product_hash(product)
      product_hash = described_class.add_taxons(product)
      expect(described_class.add_taxons(product)).to eq('5')
    end
  end

  describe '.add_hollander_number' do
    before(:each) do
      @property = Spree::Property.create(name: "rr_sku", presentation: "RR SKU")      
      Spree::ProductProperty.create(product_id: product.id, property_id: @property.id, value: "23232")
      
      @property2 = Spree::Property.create(name: "hollander_number", presentation: "Hollander Number")      
      Spree::ProductProperty.create(product_id: product.id, property_id: @property2.id, value: "01234")
    end
    
    it 'should accept a :product object as a parameter' do
      allow(described_class).to receive(:add_hollander_number).with(product)
    end

    it "Should return hollander number when exist" do
      described_class.generate_product_hash(product)
      product_hash = described_class.add_hollander_number(product)
      expect(described_class.add_hollander_number(product)).to eq('560-01234')
      expect(described_class.add_hollander_number(product)).to_not eq '560-01235'
    end

    it "Should return rr SKU when hallander number doesn't exist" do
      Spree::ProductProperty.where(product_id: product.id, property_id: @property2.id).first.update(value: nil)

      described_class.generate_product_hash(product)
      product_hash = described_class.add_hollander_number(product)
      expect(described_class.add_hollander_number(product)).to eq('560-23232')
    end

  end

  describe '.calculate_price' do
    it 'should accept a :price as am argument' do
      allow(described_class).to receive(:calculate_price).with(200)
    end

    it 'should return the calculated price value price + 0.08' do
      expect(described_class.send(:calculate_price, 100)).to eq(108)
    end
  end

  describe '.hollander_number' do
    before(:each) do
      @property2 = Spree::Property.create(name: "hollander_number", presentation: "Hollander Number")      
      Spree::ProductProperty.create(product_id: product.id, property_id: @property2.id, value: "01231")
    end
    
    it 'should accept a :product object as a parameter' do
      allow(described_class).to receive(:hollander_number).with(product)
    end

    it "Should return hollander number" do
      expect(described_class.send(:hollander_number, product)).to eq('01231')
    end

     it "Should return nil when no hollander number" do
      Spree::ProductProperty.where(product_id: product.id, property_id: @property2.id).first.update(value: nil)
      expect(described_class.hollander_number(product)).to be_nil
    end

    it "Should return nil when exception" do
      Spree::ProductProperty.where(property_id: @property2.id).first.update!(value: '12341', product_id: nil)
      expect(described_class.hollander_number(product)).to be_nil
    end

  end

end