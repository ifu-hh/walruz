require File.dirname(__FILE__) + "/../../spec_helper"

describe Walruz::CoreExt::Array do
  
  it "should add an 'only_authorized_for' method" do
    expect([]).to respond_to(:only_authorized_for)
  end
  
  describe "#only_authorized_for" do
    
    before(:each) do
      @songs = [
        Song::A_DAY_IN_LIFE,
        Song::YELLOW_SUBMARINE,
        Song::TAXMAN,
        Song::YESTERDAY,
        Song::ALL_YOU_NEED_IS_LOVE,
        Song::BLUE_JAY_WAY,
      ]
    end
    
    describe "using an action as a parameter with option :action" do
      
      shared_examples_for "only_authorized with action as a parameter expectations" do
        
        it "should remove the elements that are not authorized" do
          expect(@songs.only_authorized_for(Beatle::JOHN, @options)).to eq([
                                                                 Song::A_DAY_IN_LIFE, 
                                                                 Song::YELLOW_SUBMARINE, 
                                                                 Song::TAXMAN, 
                                                                 Song::ALL_YOU_NEED_IS_LOVE])
          expect(@songs.only_authorized_for(Beatle::PAUL, @options)).to eq([
                                                                 Song::A_DAY_IN_LIFE,
                                                                 Song::YELLOW_SUBMARINE,
                                                                 Song::YESTERDAY])
          expect(@songs.only_authorized_for(Beatle::GEORGE, @options)).to eq([Song::TAXMAN, Song::BLUE_JAY_WAY])
          expect(@songs.only_authorized_for(Beatle::RINGO, @options)).to be_empty
        end

      end
      
      describe "with a hash and an option :action" do

        before(:each) do
          @options = { :action => :sing }
        end
        
        it_should_behave_like "only_authorized with action as a parameter expectations"
        
      end
      
      describe "with just a symbol" do

        before(:each) do
          @options = :sing
        end

        it_should_behave_like "only_authorized with action as a parameter expectations"
        
      end
      
    end
    
    describe "with option :policy" do
      
      before(:each) do
        @options = { :policy => :in_colaboration }
      end
      
      it "should remote the elements that are not authorized" do
        expect(@songs.only_authorized_for(Beatle::JOHN, @options)).to eq([Song::A_DAY_IN_LIFE, 
                                                                  Song::YELLOW_SUBMARINE, 
                                                                  Song::TAXMAN])
        expect(@songs.only_authorized_for(Beatle::PAUL, @options)).to eq([Song::A_DAY_IN_LIFE,
                                                                  Song::YELLOW_SUBMARINE])
        expect(@songs.only_authorized_for(Beatle::GEORGE, @options)).to eq([Song::TAXMAN])
        expect(@songs.only_authorized_for(Beatle::RINGO, @options)).to be_empty
      end
      
    end
    
  end
  
end
