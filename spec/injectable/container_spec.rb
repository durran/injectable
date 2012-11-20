require "spec_helper"

describe Injectable::Container do

  describe "#get" do

    before(:all) do
      class User; end
      class UserFinder; end
      class UserService
        include Injectable
        dependencies :user, :user_finder
      end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
      Object.__send__(:remove_const, :UserFinder)
      Object.__send__(:remove_const, :UserService)
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
        expect(container.get(UserService)).to eql(service)
      end
    end

    context "when a cached instance does not exist in the container" do

      let(:container) do
        described_class.new(user, finder)
      end

      it "returns a new instance" do
        expect(container.get(UserService)).to be_a(UserService)
      end

      it "caches the instance" do
        expect(container.get(UserService)).to eql(container.get(UserService))
      end
    end
  end
end
