require 'rails_helper'

RSpec.describe "Api::V1::Events", type: :request do
  describe "POST /api/v1/events" do
    let(:valid_params) do
      {
        event: {
          title: "test title",
          password: "password",
          password_confirmation: "password",
          candidates_attributes: [
            { start_time: "2026-03-20T10:00", end_time: "2026-03-20T22:00" },
            { start_time: "2026-03-21T10:00", end_time: "2026-03-21T22:00" }
          ]
        }
      }
    end

    context "when params are valid" do
      it "creates a new event and returns 201" do
        expect {
          post "/api/v1/events", params: valid_params
        }.to change(Event, :count).by(1).and change(Candidate, :count).by(2)

        expect(response).to have_http_status(:created) # 201

        json = JSON.parse(response.body)
        expect(json["title"]).to eq "test title"
        expect(json["url_token"]).to be_present
      end
    end

    context "when title is empty" do
      it "does not create an event and returns 422" do
        invalid_params = valid_params.deep_merge({ event: { title: "" } })

        expect {
            post "/api/v1/events", params: invalid_params
          }.not_to change(Event, :count)

        expect(response).to have_http_status(:unprocessable_content) # 422
      end
    end
  end

  describe "DELETE /api/v1/events/:url_token" do
    let!(:event) { create(:event, password: "password", password_confirmation: "password") }

    context "when password is correct" do
      it "deletes the event and returns 200" do
        expect {
          delete "/api/v1/events/#{event.url_token}", params: { password: "password" }
        }.to change(Event, :count).by(-1)
        expect(response).to have_http_status(:ok) # 200
      end
    end

    context "when password is incorrect" do
      it "does not delete the event and returns an error response" do
        expect {
          delete "/api/v1/events/#{event.url_token}", params: { password: "wrong_password" }
        }.to change(Event, :count).by(0)

        expect(response).to have_http_status(:unauthorized) # 401

        json = JSON.parse(response.body)
        expect(json["error"]).to eq "パスワードが間違っています"
      end
    end
  end

  describe "GET /api/v1/events/:url_token" do
    let!(:event) { create(:event, url_token: "valid-token") }
    let!(:user) { create(:user, name: "test-user", event: event) }
    let!(:candidate) { create(:candidate, event: event) }
    let!(:response_data) { create(:response, user: user, candidate: candidate, status: 2) }

    context "when the event exists" do
      it "requires the event details and 200 OK" do
        get "/api/v1/events/#{event.url_token}"

        expect(response).to have_http_status(:ok) # 200

        json = JSON.parse(response.body)
        expect(json["title"]).to eq "test-event"
        expect(json["url_token"]).to eq "valid-token"
      end

      it "returns event with nested users and responses" do
        get "/api/v1/events/#{event.url_token}"

        expect(response).to have_http_status(:ok) # 200
        json = JSON.parse(response.body)

        expect(json["url_token"]).to eq "valid-token"
        expect(json["users"]).to be_any { |u| u["name"] == "test-user" }

        user_json = json["users"].find { |u| u["name"] == "test-user" }
        expect(user_json["responses"].length).to eq 1
        expect(user_json["responses"][0]["status"]).to eq 2
      end
    end

    context "when the event does not exists" do
      it "returns 404 Not Found" do
        get "/api/v1/events/invalid-token"

        expect(response).to have_http_status(:not_found) # 404

        json = JSON.parse(response.body)
        expect(json["error"]).to be_present
      end
    end
  end
end
