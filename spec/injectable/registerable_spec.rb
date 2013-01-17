require "spec_helper"

describe Injectable::Registerable do

  describe ".included" do

    before(:all) do
      class Register
        include Injectable::Registerable
      end
      class User; end
      class SuperUser; end
    end

    after(:all) do
      Object.__send__(:remove_const, :Register)
      Object.__send__(:remove_const, :User)
    end

    let(:register) do
      Register.new
    end

    context "when registering a single implementation" do

      let(:implementation) do
        register.register_implementation(:admin, User)
      end

      it "adds the implementation" do
        expect(implementation).to eq([ User ])
      end
    end

    context "when registering multiple implementations" do

      let(:implementation) do
        register.register_implementation(:admin, User, SuperUser)
      end

      it "adds the implementation" do
        expect(implementation).to eq([ User, SuperUser ])
      end
    end

    context "when registering multiple with an array" do

      let(:implementation) do
        register.register_implementation(:admin, [ User, SuperUser ])
      end

      it "adds the implementation" do
        expect(implementation).to eq([ User, SuperUser ])
      end
    end
  end
end
