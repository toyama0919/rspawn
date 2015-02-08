require 'spec_helper'
require 'rspawn'

describe Rspawn::CLI do
  before do
  end

  it "should stdout sample" do
    output = capture_stdout do
      Rspawn::CLI.start(['help'])
    end
    output.should_not nil
  end

  after do
  end
end
