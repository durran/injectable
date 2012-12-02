require "spec_helper"

describe Injectable do

  describe ".configure" do

    before(:all) do
      class Admin; end
    end

    after(:all) do
      Object.__send__(:remove_const, :Admin)
    end

    context "when provided a block" do

      before do
        described_class.configure do |registry|
          registry.register_implementation(:admin, Admin)
        end
      end

      let(:implementation) do
        Injectable::Registry.implementation(:admin)
      end

      it "delegates to the registry" do
        expect(implementation).to eq(Admin)
      end
    end

    context "when not provided a block" do

      let(:registry) do
        described_class.configure
      end

      it "returns the registry" do
        expect(registry).to eq(Injectable::Registry)
      end
    end
  end

  describe ".included" do

    before(:all) do
      class User
        include Injectable
      end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
    end

    let(:implementation) do
      Injectable::Registry.implementation(:user)
    end

    it "adds the user to the implementations" do
      expect(implementation).to eq(User)
    end
  end
end
