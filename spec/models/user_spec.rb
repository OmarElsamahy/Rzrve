# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    context "email uniqueness" do
      it "validates uniqueness when status is active" do
        passing_user = create(:user, status: :active)
        puts passing_user.as_json
        puts passing_user.persisted?
        puts "passing_user"
        non_passing_user = create(:user, status: :active, email: passing_user.email)
        puts non_passing_user.as_json
        puts non_passing_user.persisted?
        puts "non_passing_user"

        expect(passing_user).to be_valid
        expect(non_passing_user).not_to be_valid
      end
    end

    it "validates the format of email" do
      user = build(:user, email: "invalid_email")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should allow_value('valid_password123').for(:password) }
    it { should_not allow_value('weak').for(:password) }

    it { should allow_value('123456789').for(:phone_number) }
  end

  describe "associations" do
    # it { should have_many(:devices).dependent(:destroy) }
  end

  describe "scopes" do
  end

  describe "methods" do
  end

  describe "callbacks" do
  end
end
