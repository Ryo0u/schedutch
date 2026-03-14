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
  
  describe "associations" do
    it "destroys associated candidates, users, and responses when deleted" do
      event = create(:event)
      candidate = create(:candidate, event: event)
      user = create(:user, event: event)
      create(:response, user: user, candidate: candidate)
      
      expect { event.destroy }.to change { Candidate.count }.by(-1)
                                       .and change { User.count }.by(-1)
                                       .and change { Response.count }.by(-1)
    end
  end
end
