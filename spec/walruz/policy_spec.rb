require File.dirname(__FILE__) + '/../spec_helper'

describe Walruz::Policy do
  
  it "should provide the with_actor utility" do
    expect(AuthorPolicy).to respond_to(:with_actor)
  end

  it "should not have composed policies on the global policy list by default" do
    CombinedPolicy = Walruz::Utils.any(SubjectIsActorPolicy, HelterSkellterPolicy)
    expect(Walruz.policies[:combined_policy]).to be_nil 
  end

  it "should have a composed policy in the global policy list if the label name is declared after composition" do
    CombinedPolicy = Walruz::Utils.any(SubjectIsActorPolicy, HelterSkellterPolicy)
    CombinedPolicy.set_policy_label(:combined_policy)
    expect(Walruz.policies[:combined_policy]).to eq(CombinedPolicy)
  end
  
  it "should generate an indicator that the policy was executed after authorization queries" do
    policy = Beatle::PAUL.authorize(:sing, Song::YESTERDAY)
    expect(policy[:author_policy?]).to be_truthy
  end
  
  it "should have a default label" do
    expect(AuthorPolicy.policy_label).to eq(:author_policy)
  end
  
  it "should prioritize a label that is setted over the default one" do
    AuthorPolicy.set_policy_label :is_author
    expect(AuthorPolicy.policy_label).to eq(:is_author)
    AuthorPolicy.set_policy_label(nil)
  end
  
  it "should raise an Walruz::ActionNotFound exception when the action is not specified, and there is no default one"  do
    expect do
      Beatle::RINGO.authorize(:sing_drunk, Song::TAXMAN)
    end.to raise_error(Walruz::ActionNotFound)
  end
  
  describe "when using the #with_actor method" do
    
    before(:each) do
      @songs = [Song::A_DAY_IN_LIFE, Song::YELLOW_SUBMARINE, Song::TAXMAN,
                Song::YESTERDAY, Song::ALL_YOU_NEED_IS_LOVE, Song::BLUE_JAY_WAY]
    end
    
    it "should work properly" do
      george_authorship_songs = @songs.select(&AuthorPolicy.with_actor(Beatle::GEORGE))
      expect(george_authorship_songs).to have(1).song
      expect(george_authorship_songs).to eq([Song::BLUE_JAY_WAY])
      
      
      john_and_paul_songs = @songs.select(&AuthorInColaborationPolicy.with_actor(Beatle::JOHN))
      expect(john_and_paul_songs).to have(3).songs
      expect(john_and_paul_songs).to eq([Song::A_DAY_IN_LIFE, Song::YELLOW_SUBMARINE, Song::TAXMAN])
    end
    
  end
  
  describe "when using dependence_on macro" do
    
    it "should work properly" do
      expect do
        Beatle::PAUL.sing_with_john(Song::YESTERDAY)
      end.to raise_error(Walruz::NotAuthorized)
      
      expect(Beatle::PAUL.sing_with_john(Song::A_DAY_IN_LIFE)).to eq("Ok John, Let's Play 'A Day In Life'")
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
      expect do
        Beatle::PAUL.authorize!(:sing, Song::YESTERDAY)
      end.to raise_error(Walruz::NotAuthorized, "I wanna sing helter skellter!!! YEAAAHHH")
    end

    describe "on composed policies" do

      before(:each) do
        expect(AuthorPolicy).not_to receive(:new)
      end
      
      it "should not invoke any other policy" do
        Beatle::PAUL.can?(:sing, Song::YESTERDAY)
      end

    end

  end
  
end
