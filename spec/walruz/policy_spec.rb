require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz::Policy do
  
  it "should provide the with_actor utility" do
    AuthorPolicy.should respond_to(:with_actor)
  end

  it "should not have composed policies on the global policy list by default" do
    CombinedPolicy = Walruz::Utils.any(SubjectIsActorPolicy, HelterSkellterPolicy)
    Walruz.policies[:combined_policy].should be_nil 
  end

  it "should have a composed policy in the global policy list if the label name is declared after composition" do
    CombinedPolicy = Walruz::Utils.any(SubjectIsActorPolicy, HelterSkellterPolicy)
    CombinedPolicy.set_policy_label(:combined_policy)
    Walruz.policies[:combined_policy].should == CombinedPolicy
  end
  
  it "should generate an indicator that the policy was executed after authorization queries" do
    policy = Beatle::PAUL.authorize(:sing, Song::YESTERDAY)
    policy[:author_policy?].should be_true
  end
  
  it "should have a default label" do
    AuthorPolicy.policy_label.should == :author_policy
  end
  
  it "should prioritize a label that is setted over the default one" do
    AuthorPolicy.set_policy_label :is_author
    AuthorPolicy.policy_label.should == :is_author
    AuthorPolicy.set_policy_label(nil)
  end
  
  it "should raise an Walruz::ActionNotFound exception when the action is not specified, and there is no default one"  do
    lambda do
      Beatle::RINGO.authorize(:sing_drunk, Song::TAXMAN)
    end.should raise_error(Walruz::ActionNotFound)
  end
  
  describe "when using the #with_actor method" do
    
    before(:each) do
      @songs = [Song::A_DAY_IN_LIFE, Song::YELLOW_SUBMARINE, Song::TAXMAN,
                Song::YESTERDAY, Song::ALL_YOU_NEED_IS_LOVE, Song::BLUE_JAY_WAY]
    end
    
    it "should work properly" do
      george_authorship_songs = @songs.select(&AuthorPolicy.with_actor(Beatle::GEORGE))
      george_authorship_songs.should have(1).song
      george_authorship_songs.should == [Song::BLUE_JAY_WAY]
      
      
      john_and_paul_songs = @songs.select(&AuthorInColaborationPolicy.with_actor(Beatle::JOHN))
      john_and_paul_songs.should have(3).songs
      john_and_paul_songs.should == [Song::A_DAY_IN_LIFE, Song::YELLOW_SUBMARINE, Song::TAXMAN]
    end
    
  end
  
  describe "when using dependence_on macro" do
    
    it "should work properly" do
      lambda do
        Beatle::PAUL.sing_with_john(Song::YESTERDAY)
      end.should raise_error(Walruz::NotAuthorized)
      
      Beatle::PAUL.sing_with_john(Song::A_DAY_IN_LIFE).should == "Ok John, Let's Play 'A Day In Life'"
    end
  
  end

  describe "when using the halt method inside a policy" do

    before(:each) do
      Beatle::PAUL.invoke_helter_skelter = true
    end

    after(:each) do
      Beatle::PAUL.invoke_helter_skelter = false
    end

    it "should raise a PolicyHalted exception" do
      lambda do
        Beatle::PAUL.authorize!(:sing, Song::YESTERDAY)
      end.should raise_error(Walruz::NotAuthorized, "I wanna sing helter skellter!!! YEAAAHHH")
    end

    describe "on composed policies" do

      before(:each) do
        AuthorPolicy.should_not_receive(:new)
      end
      
      it "should not invoke any other policy" do
        Beatle::PAUL.can?(:sing, Song::YESTERDAY)
      end

    end

  end
  
end
