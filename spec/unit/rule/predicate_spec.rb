# frozen_string_literal: true

RSpec.describe Dry::Logic::Rule::Predicate do
  subject(:rule) { described_class.build(predicate) }

  let(:predicate) { str? }

  include_context "predicates"

  it_behaves_like Dry::Logic::Rule

  describe "#name" do
    it "returns predicate identifier" do
      expect(rule.name).to be(:str?)
    end
  end

  describe "#to_ast" do
    context "without a result" do
      it "returns rule ast" do
        expect(rule.to_ast).to eql([:predicate, [:str?, [[:input, undefined]]]])
      end

      it "returns :failure with an id" do
        email = rule.with(id: :email)

        expect(email.(11).to_ast).to eql([:failure, [:email, [:predicate, [:str?, [[:input, 11]]]]]])
      end
    end

    context "with a result" do
      it "returns success" do
        expect(rule.("foo")).to be_success
      end

      it "returns failure ast" do
        expect(rule.(5).to_ast).to eql([:predicate, [:str?, [[:input, 5]]]])
      end
    end

    context "with a zero-arity predicate" do
      let(:predicate) {
        Module.new {
          def self.test?
            true
          end
        } .method(:test?)
      }

      it "returns ast" do
        expect(rule.to_ast).to eql([:predicate, [:test?, []]])
      end
    end
  end

  describe "#to_s" do
    it "returns string representation" do
      expect(rule.curry("foo").to_s).to eql('str?("foo")')
    end
  end
end
