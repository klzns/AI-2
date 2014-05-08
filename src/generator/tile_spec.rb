require 'rspec'
require_relative 'tile'

describe Tile do
  before(:each) { @tile = Tile.new(:g) }

  describe 'kind' do
    it 'is a readable symbol' do
      @tile.kind.should be_a Symbol
    end
  end

  describe 'items' do
    it 'is a readable array' do
      @tile.items.should be_an Array
    end
  end

  describe 'limited' do
    it 'is a readable array' do
      @tile.limited.should be_an Array
    end

    it 'contains symbols' do
      @tile.limited.all? {|l| l.is_a?(Symbol)}.should be_true
    end
  end

  describe 'place' do
    it 'adds and item to the list' do
      @tile.stub(:can_place?).and_return(:true)
      expect {
        @tile.place(:B)
      }.to change {@tile.items.count}.by(1)
    end

    it 'adds the item to the list' do
      @tile.stub(:can_place?).and_return(:true)
      @tile.place(:B)
      @tile.items.last.should == :B
    end
  end

  describe 'can_place?' do
    it "can't place on forests" do
      @tile.stub(:kind).and_return(:f)
      @tile.can_place?(:B).should be_false
    end

    it "can place on grass" do
      @tile.stub(:kind).and_return(:g)
      @tile.can_place?(:B).should be_true
    end

    it 'can place when there are no items' do
      @tile.stub(:kind).and_return(:g)
      @tile.stub(:items).and_return([])

      @tile.can_place?(:B).should be_true
    end

    it "can't place when the item is repeated" do
      @tile.stub(:kind).and_return(:g)
      @tile.stub(:items).and_return([:B])

      @tile.can_place?(:B).should be_false
    end

    it "can't place when the item is limited and there are already limited items" do
      @tile.stub(:kind).and_return(:g)
      @tile.stub(:items).and_return([:E])
      @tile.stub(:limited).and_return([:B, :E])

      @tile.can_place?(:B).should be_false
    end

    it "can place otherwise" do
      @tile.stub(:kind).and_return(:g)
      @tile.stub(:items).and_return([:E])
      @tile.stub(:limited).and_return([:E])

      @tile.can_place?(:R).should be_true
    end
  end
end
