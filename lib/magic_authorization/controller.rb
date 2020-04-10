module MagicAuthorization
  module Controller
    extend ActiveSupport::Concern

    extend ::MagicAuthorization::Config
    define_setting :security_levels
    define_setting :auth_method

    # Sets the instance for the given model. The instance is found using param_col.
    # By convention, the instance name is singularized model name.
    # If the variable is found, check its owner

    # ==== Examples
    #
    #    set_model_instance(Profile, :user_id)
    #
    def set_model_instance(model:, param_col:, security_level: 0)
      # try to find the instance by parameter
      model_instance = instance_variable_set("@#{model.model_name.singular}", model.find_by(id: params[param_col]))
      
      # early return if the instance is not found
      unless model_instance
        return render(json: {
                        errors: {
                          generic: "#{model} not found"
                        }
                      },
                      status: :not_found) 
      end

      # logger.info(@@auth_method)
      unless current_user.has_role?(:admin)
        logger.info "Not admin; #{model_instance}"
        if get_owner_of(model_instance).id != current_user.id
          logger.info "current user id is #{current_user.id}"
          logger.info "instance owner id is #{get_owner_of(model_instance).id}"
          logger.info "Not current_user; #{model_instance}"
          return render(json: {
                          errors: {
                            generic: "You are not allowed to edit this #{model}. This incident will be reported"
                          }
                        },
                        status: :unauthorized)
        end
      end

      model_instance
      
    end
    
    def get_owner_of(model_instance)
      if model_instance.respond_to?(:owner_model)
        logger.info("model instance responds, so try to get owner")
        # logger.info(model_instance.send(model_instance.owner_model)
        get_owner_of(model_instance.send(model_instance.owner_model))
      else
        model_instance
      end
    end

    
    # end

  end
end

