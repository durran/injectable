require "spec_helper"

describe Injectable::Registry do

  describe "#implementation" do

    before(:all) do
      class User; end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
    end

    context "when the implementation is registered" do

      let(:implementation) do
        described_class.implementation(:persistable)
      end

      before do
        described_class.register_implementation(:persistable, User)
      end

      it "returns the implementing class" do
        expect(implementation).to eq([ User ])
      end
    end

    context "when the implmentation is not registered" do

      let(:implementation) do
        described_class.implementation(:printable)
      end

      it "raises an error" do
        expect {
          implementation
        }.to raise_error(Injectable::Registry::NotRegistered)
      end

      it "sets the proper error message" do
        begin
          implementation
        rescue Injectable::Registry::NotRegistered => e
          expect(e.message).to eq("No implementation registered for name: :printable.")
        end
      end
    end
  end

  describe "#register_signature" do

    before(:all) do
      class User; end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
    end

    before do
      described_class.register_implementation(:persistable, User)
    end

    it "remembers the dependencies of the class" do
      expect(described_class.implementation(:persistable)).to eq([ User ])
    end
  end

  describe "#register_signature" do

    before(:all) do
      class User; end
      class UserFinder; end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
      Object.__send__(:remove_const, :UserFinder)
    end

    before do
      described_class.register_signature(User, [ :user_finder ])
    end

    it "remembers the dependencies of the class" do
      expect(described_class.signature(User)).to eq([ :user_finder ])
    end
  end
end
