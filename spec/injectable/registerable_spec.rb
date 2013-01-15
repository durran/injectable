require "spec_helper"

describe Injectable::Registerable do

  describe ".included" do

    before(:all) do
      class Register
        include Injectable::Registerable
      end
      class User; end
    end

    after(:all) do
      Object.__send__(:remove_const, :Register)
      Object.__send__(:remove_const, :User)
    end

    let(:register) do
      Register.new
    end

    let(:implementation) do
      register.register_implementation(:admin, User)
    end

    it "adds the user to the implementations" do
      expect(implementation).to eq(User)
    end
  end
end
