require "rails_helper"

describe Coupon, type: :model do 
  describe "validations" do 
    it { should validate_presence_of :name }
    it { should validate_presence_of :percentage_off }
    it { should validate_presence_of :coupon_code }
  end

  describe "relationships" do 
    it { should belong_to :merchant }
  end 
end
