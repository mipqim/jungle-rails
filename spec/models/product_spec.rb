require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do

    subject {described_class.new(
      name: "Test_product", 
      price_cents: 1000, 
      quantity: 1 , 
      category: @category
    )}

    before do  
      @category = Category.create(
        name: "Test_category"
      )      
      subject.save
    end   

    it "is valid with defalt values" do
      expect(subject).to be_valid
    end    

    it 'is invalid if it has no name' do
      subject.name = nil     
      expect(subject).to_not be_valid      
    end

    it 'is invalid if it has no price' do
      subject.price_cents = nil  
      expect(subject).to_not be_valid
    end

    it 'is invalid if it has no quantity' do
      subject.quantity = nil
      expect(subject).to_not be_valid
    end 

    it 'is invalid if it has no category' do
      subject.category = nil
      expect(subject).to_not be_valid
    end 

  end

end
