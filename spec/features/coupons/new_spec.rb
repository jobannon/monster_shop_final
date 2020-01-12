require 'rails_helper'

RSpec.describe "as a merchant user" do 
  describe "when I visit the the merchant coupons show page" do 
    before(:each) do 
      @target = Merchant.create!(name: "target", address: "100 some drive", city: "denver", state: "co", zip: 80023)
      @coupon_1 = {name: "Summer Saver", coupon_code: "sum-save", percentage_off: 10, merchant_id: @target.id}
      @merchant_user = User.create!(name: "show merch", address: "show", city: "denver", state: "co", zip: 80023, role: 2, email: "joe3@ge.com", password: "password")

      @target.users << @merchant_user 
      
      #log in as a merch
      visit login_path

      fill_in :email, with: @merchant_user.email 
      fill_in :password, with: "password"

      click_button 'Log In'
    end 

    it "allows me to create a coupon" do 
      visit merchant_dashboard_path

      click_link "Coupons"
      expect(current_path).to eq(merchant_coupons_path)

      within "#coupon_actions" do 
        click_button "Create A New Coupon"
      end
      expect(current_path).to eq(new_merchant_coupon_path)

      #not sure why this is required ... to avoid a 404 error 
      visit new_merchant_coupon_path 

      fill_in :name, with: @coupon_1[:name]
      fill_in :coupon_code, with: @coupon_1[:coupon_code]
      fill_in :percentage_off, with: @coupon_1[:percentage_off]

      click_button "Create Coupon"

      coupon = Coupon.last
      binding.pry
      expect(coupon.name).to eq(@coupon_1[:name])
      expect(coupon.coupon_code).to eq(@coupon_1[:coupon_code])
      expect(coupon.percentage_off).to eq(@coupon_1[:percentage_off])
    end
  end
end
