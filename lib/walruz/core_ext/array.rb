module Walruz
  module CoreExt
    module Array
  
      # @overload only_authorized_for(actor, options = {})
      #   Filters the +Walruz::Subject+ elements inside an array either by a policy or by an action on the _subject_. 
      #   This will execute the authorization policies using specified _actor_ and action/policy.
      #   === Notes:
      #   * If a policy is given, you have to use the policy label.
      #   * If an action is given, you have to use the name of the action declared on the subject.
      # 
      #   @param [Walruz::Actor] actor The _actor_ that is going to be used on the authorization process
      # 
      #   @param [Hash] opts for the filtering process.
      #   @option opts [Symbol] :action The name of the action to be executed on the list of subjects.
      #   @option opts [Symbol] :policy The label of an specific policy that is going to be used.
      # 
      #   @return [Array<Walruz::Subject>] An array with the authorized subjects.
      # 
      #   @raise [Walruz::ActionNotFound] if the opts[:action] is not specified on the subject or 
      #     if the opts[:policy] label identifying the policy is not recognized
      # 
      #   @example Filtering a list of Posts by the read action specified on the Post class
      #     Post.all.only_authorized_for(current_user, :action => :read)
      #     # this will execute current_user.can?(:read, post) for each element of the array
      # 
      #   @example Filtering a list of Posts by a policy
      #     Post.all.only_authorized_for(nil, :policy => :public_policy)
      #     # This will execute the Policy with the label ":public_policy" on every post using the given actor
      #
      # @overload only_authorized_for(actor, action)
      #   Filters the +Walruz::Subject+ elements inside an array by the action specified. 
      #   This will execute the authorization policies using specified actor and action on each _subject_ of the +Array+.
      #
      #   @param [Walruz::Actor] actor The _actor_ that is going to be used on the authorization process
      #
      #   @param [Symbol] action to be executed by the _actor_ on each _subject_ in the list.
      #
      #   @return [Array<Walruz::Subject>] An array with the authorized of _subjects_.
      #
      #   @raise [Walruz::ActionNotFound] if the _action_ specified is not declaredon the _subject_.
      #
      #   @example Filtering a list of Posts by the read action specified on the Post class
      #     Post.all.only_authorized_for(current_user, :read)
      #     # this will execute current_user.can?(:read, post) for each element of the array
      #
      def only_authorized_for(actor, opts = {})
        if opts.respond_to?(:to_hash)
          only_authorized_with_options(actor, opts.to_hash)
        else # use the opts 
          only_authorized_on_action(actor, opts)
        end
      end
      
      protected
      
      def only_authorized_with_options(actor, opts)
        raise ArgumentError.new("You have to specify either the :action or :policy option") if opts[:action] && opts[:policy]
        if opts[:action]
          self.select do |subject|
            actor.can?(opts[:action], subject)
          end
        elsif opts[:policy]
          policy_clz = Walruz.fetch_policy(opts[:policy])
          self.select(&policy_clz.with_actor(actor))
        else
          raise ArgumentError.new("The option hash requires either :action or :policy option")
        end
      end
      
      def only_authorized_on_action(actor, action)
        self.select do |subject|
          actor.can?(action, subject)
        end
      end
      
    end
  end
end
