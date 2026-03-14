require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "validations" do
    it "is valid with a title, url_token, and password" do
      expect(build(:event)).to be_valid  
    end
    
    it 'is invalid without a title' do
      expect(build(:event, title: '')).to be_invalid
    end

    it 'is invalid with a duplicate url_token' do
      create(:event, url_token: 'same_token')
      duplicate_event = build(:event, url_token: 'same_token')
      expect(duplicate_event).to be_invalid
    end

    it 'is invalid without a password' do
      expect(build(:event, password: '', password_confirmation: '')).to be_invalid
    end
  end
end
