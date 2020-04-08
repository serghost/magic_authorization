module MagicAuthorization
  class Railtie < Rails::Railtie
    initializer "magic_authorization.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include MagicAuthorization::Controller
      end
    end
  end
end
