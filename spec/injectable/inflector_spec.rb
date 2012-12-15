require "spec_helper"

describe Injectable::Inflector do

  describe ".underscore" do

    context "when provided a non namespaced name" do

      context "when the name is one word" do

        let(:inflected) do
          described_class.underscore("Band")
        end

        it "returns the name as lowercase" do
          expect(inflected).to eq("band")
        end
      end

      context "when the name is multiple words" do

        let(:inflected) do
          described_class.underscore("BandService")
        end

        it "returns the name as lowercase" do
          expect(inflected).to eq("band_service")
        end
      end
    end
  end
end
