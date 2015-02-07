require 'spec_helper'
require 'dmon'

describe Dmon::CLI do
  before do
  end

  it "should stdout sample" do
    output = capture_stdout do
      Dmon::CLI.start(['help'])
    end
    output.should_not nil
  end

  after do
  end
end
