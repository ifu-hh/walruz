module Walruz

  class Config

    def self.add_authorization_query_methods_to(base)
      base.extend(Walruz::Manager::AuthorizationQuery)
      class << base
        include Walruz::Memoization
        walruz_memoize :can?, :authorize, :satisfies, :satisfies?
      end
    end

    def enable_array_extension
      require File.expand_path(File.join(File.dirname(__FILE__), 'core_ext', 'array'))
      safe_include(Array, Walruz::CoreExt::Array)
    end

    def actors=(actors)
      Array(actors).each do |actor|
        actor.send(:include, Walruz::Actor)
      end
    end

    def subjects=(subjects)
      Array(subjects).each do |subject|
        subject.send(:include, Walruz::Subject)
      end
    end

    protected

    def safe_include(base, module_to_include)
      return if base.included_modules.include?(module_to_include)
      base.send(:include, module_to_include)
    end

  end

end
