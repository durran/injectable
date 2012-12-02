require "spec_helper"

describe Injectable do

  describe ".included" do

    before(:all) do
      class User
        include Injectable
      end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
    end

    it "adds the user to the implementations" do
      expect(Injectable::Registry.implementation(:user)).to eq(User)
    end
  end
end
