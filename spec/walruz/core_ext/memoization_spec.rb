require File.dirname(__FILE__) + "/../../spec_helper"

describe Walruz::Memoization do

  before(:each) do
    @foo = Foo.new 
  end

  it "should invoke the original method the first time" do
    expect(@foo.highcost).to eq("This is the first time")
  end

  it "should invoke the memoized result the second time" do
    expect(@foo.highcost).to eq("This is the first time")
    expect(@foo.highcost).to eq("This is the first time")
  end

  it "should invoke the method once memoized if and only if the reload parameter is given" do
    expect(@foo.highcost).to eq("This is the first time")
    expect(@foo.highcost(:reload)).to eq("This is the second time")
  end

end
