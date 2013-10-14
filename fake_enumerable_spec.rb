require 'rspec'
require_relative 'SortedList.rb'

describe SortedList do

  describe "FakeEnumerable" do
    before :each do
      @list = SortedList.new
      @list << 3 << 13 << 42 << 4 << 7
    end

    it "supports map" do
      @list.map { |x| x + 1 }.should eq ([4, 5, 8, 14, 43])
    end

    it "supports sort_by" do
      # ascii sort order
      @list.sort_by { |x| x.to_s }.should eq ([13, 3, 4, 42, 7])
    end

    it "supports select" do
      @list.select { |x| x.even? }.should eq ([4, 42])
    end

    it "supports reduce" do
      @list.reduce(:+).should eq (69)
      @list.reduce { |s, e| s + e }.should eq (69)
      @list.reduce(-10) { |s, e| s + e }.should eq (59)
    end
  end

end