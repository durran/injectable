require "spec_helper"

describe Injectable::Container do

  describe "#get" do

    before(:all) do
      class User
        include Injectable
      end
      class UserFinder
        include Injectable
      end
      class UserService
        include Injectable
        dependencies :user, :user_finder
      end
      class AnotherUserFinder; end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
      Object.__send__(:remove_const, :UserFinder)
      Object.__send__(:remove_const, :UserService)
      Object.__send__(:remove_const, :AnotherUserFinder)
    end

    let(:user) do
      User.new
    end

    let(:finder) do
      UserFinder.new
    end

    context "when a cached instance exists in the container" do

      let(:service) do
        UserService.new(user, finder)
      end

      let(:container) do
        described_class.new(service)
      end

      it "returns the cached instance" do
        expect(container.get(:user_service)).to eql(service)
      end
    end

    context "when a cached instance does not exist in the container" do

      let(:container) do
        described_class.new(user, finder)
      end

      it "returns a new instance" do
        expect(container.get(:user_service)).to be_a(UserService)
      end

      it "caches the instance" do
        expect(container.get(:user_service)).to eql(container.get(:user_service))
      end
    end

    context "when no arg dependencies are not in the container" do

      let(:container) do
        described_class.new
      end

      it "returns a new instance" do
        expect(container.get(:user_service)).to be_a(UserService)
      end

      it "returns instances of the no arg objects" do
        expect(container.get(:user)).to be_a(User)
        expect(container.get(:user_finder)).to be_a(UserFinder)
      end
    end

    context "when a specified class is registered for a given role" do

      let(:container) do
        described_class.new
      end

      let(:user_service) do
        container.get(:user_service)
      end

      before do
        container.register_implementation(:user_finder, AnotherUserFinder)
      end

      it "returns an instance of the specified class for that role" do
        expect(container.get(:user_finder)).to be_an(AnotherUserFinder)
      end

      it "continues to wire up dependent objects correctly" do
        expect(user_service.user_finder).to be_an(AnotherUserFinder)
      end
    end

    context "when asked for a role but no class registered" do

      let(:container) do
        described_class.new
      end

      it "returns the an instance of the class most likely to match the role" do
        expect(container.get(:user_finder)).to be_a(UserFinder)
      end

      context "and there's no defined constant matching the role name" do

        it "raises an error" do
          expect {
            container.get(:renderable)
          }.to raise_error(Injectable::Registry::NotRegistered)
        end
      end
    end
  end
end
