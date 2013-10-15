require 'rspec'
require_relative 'sorted_list.rb'

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



  describe "FakeEnumerator" do
    before do
      @list = SortedList.new
      @list << 3 << 13 << 42 << 4 << 7
    end

    it "supports next" do
      enum = @list.each

      enum.next.should eq(3)
      enum.next.should eq(4)
      enum.next.should eq(7)
      enum.next.should eq(13)
      enum.next.should eq(42)

      ->{ enum.next }.should raise_error(StopIteration)
    end

    it "supports rewind" do
      enum = @list.each

      4.times { enum.next }
      enum.rewind

      2.times { enum.next }
      enum.next.should eq(7)
    end

    it "supports with_index" do
      enum     = @list.map
      expected = ["0. 3", "1. 4", "2. 7", "3. 13", "4. 42"]

      enum.with_index { |e, i| "#{i}. #{e}" }.should eq(expected)
    end
  end


end