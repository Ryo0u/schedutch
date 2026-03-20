require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let!(:event) { create(:event, url_token: "test_token_123") }

  let!(:candidate1) do
    create(:candidate,
      event: event,
      start_time: "2026-03-20 10:00:00",
      end_time: "2026-03-20 12:00:00"
    )
  end
  let!(:candidate2) do
    create(:candidate,
      event: event,
      start_time: "2026-03-21 10:00:00",
      end_time: "2026-03-21 12:00:00"
    )
  end

  describe "POST /api/v1/events/:event_url_token/users" do
    let(:url) { "/api/v1/events/#{event.url_token}/users" }

    context "when valid params are provided" do
      let(:valid_params) do
        {
          user: {
            name: "山田太郎",
            password: "password123",
            password_confirmation: "password123"
          },
          responses: [
            {
              candidate_id: candidate1.id,
              status: 2, # △
              start_time: "2026-03-20 10:00:00"
            },
            {
              candidate_id: candidate2.id,
              status: 3, # ×
              start_time: "2026-03-21 10:00:00"
            }
          ]
        }
      end

      it "creates a user and 2 responses" do
        expect {
          post url, params: valid_params
        }.to change(User, :count).by(1).and change(Response, :count).by(2)

        puts JSON.parse(response.body) if response.status != 201
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["user"]["name"]).to eq "山田太郎"
        expect(json["user"]["responses"].length).to eq 2
      end
    end

    context "when name is empty" do
      it "does not create a user and returns 422" do
        invalid_params = { user: { name: "" } }

        expect {
          post url, params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content) # 422
      end
    end
  end

  describe "DELETE /api/v1/users/:id" do
    let!(:user) { create(:user) }

    context "with correct password" do
      it "deletes the user" do
        expect {
          delete "/api/v1/users/#{user.id}", params: { password: "userpass123" }
        }.to change(User, :count).by(-1)

        expect(response).to have_http_status(:ok) # 200
      end
    end
  end
end
