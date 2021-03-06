# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::AssignmentsController, type: :controller do
  let(:organization)          { classroom_org }
  let(:user)                  { classroom_teacher }

  before do
    @assignment = create(:assignment, organization: organization)
  end

  describe "GET #index", :vcr do
    before do
      get :index, params: { organization_id: organization.slug, access_token: user.api_token }
    end

    it "returns success" do
      expect(response).to have_http_status(:success)
    end

    it "returns only one assignment" do
      expect(json.length).to eql(1)
    end
  end

  describe "GET #show", :vcr do
    before do
      get :show, params: {
        organization_id: organization.slug,
        id: @assignment.slug,
        access_token: user.api_token
      }
    end

    it "returns success" do
      expect(response).to have_http_status(:success)
    end

    it "returns correct attributes in assignment serializer" do
      expect(json["id"]).to eq(@assignment.id)
      expect(json["title"]).to eq(@assignment.title)
      expect(json["type"]).to eq("individual")
      expect(json["organizationGithubId"]).to eq(organization.github_id)
    end
  end
end
