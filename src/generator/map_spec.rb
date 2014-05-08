require 'rspec'
require_relative 'map'

describe Map do
  before(:each) { @map = Map.new("f g \ng f \ng f \n") }

  describe 'width' do
    it 'is the length of the first line' do
      @map.width.should == 2
    end
  end

  describe 'height' do
    it 'is the number of lines' do
      @map.height.should == 3
    end
  end

  describe 'candidates_for' do
    it 'selects only valid candidates' do
      tile1 = double('tile').as_null_object
      tile1.stub(:can_place?).and_return(false)
      tile2 = double('tile').as_null_object
      tile2.stub(:can_place?).and_return(true)
      @map.stub(:tiles).and_return([tile1, tile2])

      @map.candidates_for(:B).should == [tile2]
    end
  end

  describe 'place' do
    it 'raises when there are no candidates' do
      @map.stub(:candidates_for).and_return([])
      expect {
        @map.place(:B)
      }.to raise_exception
    end

    it 'calls :place on a candidate' do
      candidates = double('candidates').as_null_object
      candidates.stub(:empty?).and_return(false)
      tile = double('tile').as_null_object
      candidates.stub(:sample).and_return(tile)
      @map.stub(:candidates_for).and_return(candidates)

      candidates.should_receive(:sample)
      @map.place(:B)
    end

    it 'selects a candidate randomly' do
      candidates = double('candidates').as_null_object
      candidates.stub(:empty?).and_return(false)
      tile = double('tile').as_null_object
      candidates.stub(:sample).and_return(tile)
      @map.stub(:candidates_for).and_return(candidates)

      tile.should_receive(:place)
      @map.place(:B)
    end
  end
end