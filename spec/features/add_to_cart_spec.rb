require 'rails_helper'

RSpec.feature 'Add To Carts', type: :feature, js: true do  
  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario 'They see all products' do
    # ACT
    visit root_path    
    first('article.product').click_button 'Add'

    # DEBUG 
    save_screenshot

    # VERIFY
    expect(page).to have_content('My Cart (1)')
 
  end
end