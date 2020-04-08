module MagicAuthorization
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_initializer
        copy_file 'magic_authorization.rb', 'config/initializers/magic_authorization.rb'
      end

    end
  end
end
