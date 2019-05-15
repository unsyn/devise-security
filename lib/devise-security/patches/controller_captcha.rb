# frozen_string_literal: true

module DeviseSecurity::Patches
  module ControllerCaptcha
    extend ActiveSupport::Concern

    included do
      prepend_before_action :check_captcha, only: [:create]
    end

    private

    def check_captcha
      return if valid_captcha_if_defined?(params[:captcha])

      flash[:alert] = t('devise.invalid_captcha') if is_navigational_format?

      # app specific: redirect to consumer login on capture failures if coming from consumer login.
      action = (params[:user] && params[:user][:sign_in_type] == 'consumer') ? :new_consumer : :new

      respond_with({}, location: url_for(action: action))
    end
  end
end
