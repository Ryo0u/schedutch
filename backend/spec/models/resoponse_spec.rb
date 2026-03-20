# spec/models/response_spec.rb
require 'rails_helper'

RSpec.describe Response, type: :model do
  describe 'validations' do
    it 'is valid with a user, candidate, start_time, and status' do
      expect(build(:response)).to be_valid
    end

    it 'is invalid without a user' do
      expect(build(:response, user: nil)).to be_invalid
    end

    it 'is invalid without a candidate' do
      expect(build(:response, candidate: nil)).to be_invalid
    end

    it 'is invalid if a user answers the same candidate twice' do
      first_response = create(:response)

      duplicate_response = build(:response,
        user: first_response.user,
        candidate: first_response.candidate,
        start_time: first_response.start_time
      )

      expect(duplicate_response).to be_invalid
    end
  end
end
