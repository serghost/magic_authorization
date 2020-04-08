MagicAuthorization.configure do |config|
  config.security_levels = 2
  config.auth_method do
    current_user.has_role?(:admin)
  end
end
