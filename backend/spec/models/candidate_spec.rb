require 'rails_helper'

RSpec.describe Candidate, type: :model do
  describe 'validations' do
    it 'is valid with a start_time, end_time and event' do
      expect(build(:candidate)).to be_valid
    end

    it 'is invalid without a start_time' do
      expect(build(:candidate, start_time: nil)).to be_invalid
    end
    
    it 'is invalid without a end_time' do
      expect(build(:candidate, end_time: nil)).to be_invalid
    end
    
    it 'is invalid without an event' do
      expect(build(:candidate, event: nil)).to be_invalid
    end
  end
end