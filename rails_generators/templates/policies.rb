module Policies
  extend Walruz::Utils
  
  #
  # Add an autoload invocation to the policies you implement on the policies
  # directory. 
  # Examples:
  #   autoload :AdminPolicy, 'policies/admin'
  #   autoload :FooPolicy, 'policies/other'
  
  
  #
  # Then use it on your models:
  #
  # class ASubject
  #   check_authorization :create => Policies::AdminPolicy
  # end
  #
  
  #
  #
  # If you want to use combined policies and give them a name you can do so
  # pretty easily using the `orP`, `andP` or `notP` helpers
  #
  # AdminOrFooPolicy = orP(AdminPolicy, FooPolicy)
  # AdminAndNotFooPolicy = andP(AdminPolicy, notP(FooPolicy))
  #
  
end