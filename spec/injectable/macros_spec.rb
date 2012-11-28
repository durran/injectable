require "spec_helper"

describe Injectable::Macros do

  describe ".dependencies" do

    before(:all) do
      class User; end
      class UserFinder; end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
      Object.__send__(:remove_const, :UserFinder)
    end

    context "when providing a single dependency" do

      before(:all) do
        class UserService
          include Injectable
          dependencies :user
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserService)
      end

      let(:user) do
        User.new
      end

      let(:service) do
        UserService.new(user)
      end

      it "provides an attribute reader for the dependency" do
        expect(service.user).to eq(user)
      end

      it "adds the signature to the registry" do
        expect(Injectable::Registry.signature(UserService)).to eq([ :user ])
      end
    end

    context "when providing multiple dependencies" do

      before(:all) do
        class UserService
          include Injectable
          dependencies :user, :user_finder
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserService)
      end

      let(:user) do
        User.new
      end

      let(:finder) do
        UserFinder.new
      end

      let(:service) do
        UserService.new(user, finder)
      end

      it "provides an attribute reader for each dependency" do
        expect(service.user).to eq(user)
        expect(service.user_finder).to eq(finder)
      end

      it "adds the signature to the registry" do
        expect(
          Injectable::Registry.signature(UserService)
        ).to eq([ :user, :user_finder ])
      end
    end
  end
end
