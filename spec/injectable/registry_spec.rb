require "spec_helper"

describe Injectable::Registry do

  describe "#add" do

    before(:all) do
      class User; end
      class UserFinder; end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
      Object.__send__(:remove_const, :UserFinder)
    end

    before do
      described_class.add(User, [ :user_finder ])
    end

    it "remembers the dependencies of the class" do
      expect(described_class.signature(User)).to eq([ :user_finder ])
    end
  end
end
