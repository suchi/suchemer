# frozen_string_literal: true

require "spec_helper"

module Suchemer
  RSpec.describe Cons do
    describe ".list/.from_array" do
      it "builds a proper list" do
        lst = Cons.list(1, 2, 3)
        expect(lst.to_a).to eq [1, 2, 3]
        expect(lst.proper_list?).to be true
      end
    end

    describe "Enumerable" do
      it "iterates over car values" do
        expect(Cons.list(1,2,3).map { |x| x * 2 }).to eq [2,4,6]
      end
    end

    describe "indexing" do
      it "supports positive and negative indices" do
        lst = Cons.list(1,2,3)
        expect(lst[0]).to eq 1
        expect(lst[1]).to eq 2
        expect(lst[-1]).to eq 3
      end
    end

    describe "reverse" do
      it "reverses a proper list" do
        expect(Cons.list(1,2,3).reverse.to_a).to eq [3,2,1]
      end

      it "raises on dotted list" do
        dotted = Cons.new(1, 2)
        expect { dotted.reverse }.to raise_error(ArgumentError)
      end
    end

    describe "append" do
      it "appends array or cons" do
        expect(Cons.list(1,2).append([3,4]).to_a).to eq [1,2,3,4]
        expect(Cons.list(1,2).append(Cons.list(3,4)).to_a).to eq [1,2,3,4]
      end
    end

    describe "equality" do
      it "compares structurally" do
        expect(Cons.list(1,2,3)).to eq Cons.new(1, Cons.new(2, Cons.new(3, nil)))
        expect(Cons.list(1,2,3)).to eq [1,2,3]
      end
    end

    describe "printing" do
      it "prints proper and dotted lists" do
        expect(Cons.list(1,2,3).to_s).to eq "(1 2 3)"
        expect(Cons.new(1, 2).to_s).to eq "(1 . 2)"
      end
    end
  end
end
