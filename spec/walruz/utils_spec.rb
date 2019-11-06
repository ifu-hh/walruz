require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz::Utils do
  
  def check_actor_can_on_subject(label, actor, subject)
    expect do
      actor.authorize!(label, subject)
    end.not_to raise_error
  end
  
  def check_actor_can_not_on_subject(label, actor, subject)
    expect do
      actor.authorize!(label, subject)
    end.to raise_error(Walruz::NotAuthorized)
  end
  
  describe "when using combinators `any`, `all` or `negate`" do
    
    it "should work properly" do
      check_actor_can_not_on_subject(:sell, Beatle::JOHN, Song::A_DAY_IN_LIFE)
      check_actor_can_on_subject(:sell, Beatle::JOHN, Song::ALL_YOU_NEED_IS_LOVE)
    end
    
  end
  
  describe "#all" do

    it "should return as policy keyword, the name of the original policies keywords concatenated with `_and_`" do
      policy_params = Beatle::JOHN.authorize(:sell, Song::ALL_YOU_NEED_IS_LOVE)
      expect(policy_params[:"author_policy_and_not(in_colaboration)?"]).to be_truthy
    end
    
  end
  
  describe "#negate" do
    
    it "should return as policy keyword, the name of the original policy keyword with a `not()` around" do
      policy_params = Beatle::JOHN.authorize(:sell, Song::ALL_YOU_NEED_IS_LOVE)
      expect(policy_params[:"not(in_colaboration)?"]).to be_truthy
    end
    
  end
  
end
