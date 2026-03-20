require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with a name, password, and event" do
      expect(build(:user)).to be_valid  
    end
    
    it 'is invalid without a name' do
      expect(build(:user, name: '')).to be_invalid
    end

    it 'is invalid without an event' do
      expect(build(:user, event: nil)).to be_invalid
    end

    it 'is invalid without a password' do
      expect(build(:user, password: '', password_confirmation: '')).to be_invalid
    end
  end
  
  describe "associations" do
    it "destroys associated responses when deleted" do
      event = create(:event)
      candidate = create(:candidate, event: event)
      user = create(:user, event: event)
      create(:response, user: user, candidate: candidate)
      
      expect { user.destroy }.to change {Response.count}.by(-1)
    end
  end
end