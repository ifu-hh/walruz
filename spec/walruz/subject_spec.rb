require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz::Subject do
  
  it "should add a class method called check_authorizations" do
    expect(Song).to respond_to(:check_authorizations)
  end
  
end
