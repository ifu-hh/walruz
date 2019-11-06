require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz do

  it "should have a policies method" do
    expect(Walruz).to respond_to(:policies)
  end
  
  describe '.policies' do
    
    it "should return all the policies created that have a label" do
      expect(Walruz.policies).not_to be_nil
      expect(Walruz.policies[:author_policy]).to be_nil
      expect(Walruz.policies[:in_colaboration]).to eq(AuthorInColaborationPolicy)
      expect(Walruz.policies[:colaborating_with_john_policy]).to eq(ColaboratingWithJohnPolicy)
    end
    
  end
  
  describe ".fetch_policy" do
    
    it "should grab the policy if this is registered" do
      expect(Walruz.fetch_policy(:in_colaboration)).to eq(AuthorInColaborationPolicy)
    end
    
    it "should raise an Walruz::ActionNotFound exception if the policy is not registered" do
      expect do
        Walruz.fetch_policy(:author_in_colaboration_policy)
      end.to raise_error(Walruz::ActionNotFound)
    end
    
  end

  describe ".version" do

    it "should return a string representing the current version" do
      expect(Walruz.version).to match(/\d+\.\d+\.\d+/)
    end

  end

end
