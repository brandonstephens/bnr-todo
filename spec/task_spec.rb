require 'rspec'
require './task'

describe Task do
  subject { described_class.new(description: 'Feed the cat') }

  describe '#to_s' do
    it "returns the value of the task's description" do
      expect(subject.to_s).to eq('Feed the cat')
    end
  end
end