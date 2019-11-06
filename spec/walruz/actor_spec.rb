require File.dirname(__FILE__) + '/../spec_helper'

describe 'Walruz::Actor' do
  
  it "should add an instance method `authorize` to included classes" do
    expect(Beatle::JOHN).to respond_to(:authorize)
  end
  
  it "should add an instance method `authorize!` to included classes" do
    expect(Beatle::JOHN).to respond_to(:authorize!)
  end
  
  it "should add an instance method `can?` to included classes" do
    expect(Beatle::JOHN).to respond_to(:can?)
  end
  
  it "should add an instance method `satisfies?` to included classes" do
    expect(Beatle::JOHN).to respond_to(:satisfies?)
  end
  
  
  describe "#authorize" do
    
    it "should return nil when the actor is not authorized" do
      expect(Beatle::RINGO.authorize(:sing, Song::ALL_YOU_NEED_IS_LOVE)).to be_nil
    end
    
    it "should return the policy parameters when the actor is authorized" do
      result = Beatle::JOHN.authorize(:sing, Song::ALL_YOU_NEED_IS_LOVE)
      expect(result).not_to be_nil
      expect(result).to be_kind_of(Hash)
      expect(result[:owner]).to eq(Beatle::JOHN)
    end
    
  end
  
  describe "#authorize!" do
    
    it "should raise a Walruz::NotAuthorized error when the actor is not authorized" do
      expect do
        Beatle::RINGO.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE)
      end.to raise_error(Walruz::NotAuthorized)
    end
    
    it "should raise a Walruz::NotAuthorized error with the information of actor, subject and action when actor is not authorized" do
      begin
        Beatle::RINGO.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE)
      rescue Walruz::NotAuthorized => e
        expect(e.actor).to eq(Beatle::RINGO)
        expect(e.subject).to eq(Song::ALL_YOU_NEED_IS_LOVE)
        e.action == :sing
      end
    end
    
    it "should not raise a Walruz::NotAuthorized error when the actor is authorized" do
      expect do
        Beatle::JOHN.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE)
      end.not_to raise_error
    end
    
    it "should provide parameteres for the invokator correctly" do
      expect(Beatle::JOHN.sing_the_song(Song::ALL_YOU_NEED_IS_LOVE)).to eq("I just need myself, Let's Rock! \\m/")
      expect(Beatle::JOHN.sing_the_song(Song::YELLOW_SUBMARINE)).to eq("I need Paul to play this song properly")
    end
    
  end
  
  describe '#can?' do
    
    it "should be invoked only the first time and then return a cached solution" do
      expect(Walruz::Manager).to receive(:check_action_authorization).once.and_return([true, {}])
      Beatle::JOHN.can?(:sing, Song::YELLOW_SUBMARINE, :reload)
      Beatle::JOHN.can?(:sing, Song::YELLOW_SUBMARINE)
    end
    
    it "if a :reload symbol is passed as the third parameter it should not use the cached result" do
      allow(Walruz::Manager).to receive(:check_action_authorization).and_return([true, {}])
      expect(Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE)).to be_truthy
      
      allow(Walruz::Manager).to receive(:check_action_authorization).and_return([false, {}])
      expect(Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE)).to be_truthy
      expect(Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE, :reload)).to be_falsey
    end
    
    it "should receive at least 2 parameters" do
      expect do
        Beatle::JOHN.can?(:sing)
      end.to raise_error(ArgumentError)
    end
    
    it "should receive at most 3 parameters" do
      expect do
        Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE, :reload, false)
      end.to raise_error(ArgumentError)
    end
    
    
    it "should execute a given block that receives a hash of return parameters of the policy" do
      proc_called = lambda do |params|  
        expect(params).not_to be_nil
        expect(params).to be_kind_of(Hash)
        expect(params[:author_policy?]).to be_truthy
      end
      Beatle::JOHN.can?(:sing, Song::ALL_YOU_NEED_IS_LOVE, &proc_called)
    end
    
  end
  
  describe '#satisfies?' do
    
    it "should raise a Walruz::ActionNotFound error if the policy is not found" do
      expect do
        Beatle::GEORGE.satisfies?(:unknown_policy, Song::TAXMAN)
      end.to raise_error(Walruz::ActionNotFound)
    end
    
    it "should return false if the actor and the subject dont satisfy the given policy" do
      expect(Beatle::PAUL.satisfies?(:colaborating_with_john_policy, Song::TAXMAN)).to be_falsey
    end
    
    it "should return true if the actor and the subject satisfy the given policy" do
      expect(Beatle::GEORGE.satisfies(:colaborating_with_john_policy, Song::TAXMAN)).to be_truthy
    end
    
  end
  
  describe "#satisfies" do
    
    it "should return nil if the actor and the subject do not satisfy the given policy" do
      expect(Beatle::PAUL.satisfies(:colaborating_with_john_policy, Song::TAXMAN)).to be_nil
    end
    
    it "should return the parameters from the policy if the actor and the subject satisfy the policy" do
      policy_params = Beatle::GEORGE.satisfies(:colaborating_with_john_policy, Song::TAXMAN)
      expect(policy_params).not_to be_nil
      expect(policy_params[:in_colaboration?]).to be_truthy
    end
    
    it "should raise a Walruz::ActionNotFound error if the policy is not found" do
      expect do
        Beatle::GEORGE.satisfies(:unknown_policy, Song::TAXMAN)
      end.to raise_error(Walruz::ActionNotFound)
    end
    
  end
  
end
