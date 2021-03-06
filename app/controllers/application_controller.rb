class ApplicationController < ActionController::Base
  require "authlogic"
  include ActionView::Helpers::AssetTagHelper

  include Concerns::ApplicationController::Authentication
  include Concerns::ApplicationController::Authorization
  include Concerns::ApplicationController::Caching
  include Concerns::ApplicationController::Crud
  include Concerns::ApplicationController::ErrorHandling
  include Concerns::ApplicationController::LoginLogistics
  include Concerns::ApplicationController::Reflection
  include Concerns::ApplicationController::Routing
  include Concerns::ApplicationController::Settings

  # Makes sure authorization is performed in each controller. (CanCan method)
  check_authorization

  protect_from_forgery with: :exception, unless: -> { request.format.json? || request.format.xml? }

  rescue_from CanCan::AccessDenied, with: :handle_access_denied
  rescue_from RecentLoginRequiredError, with: :handle_recent_login_required
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity_token

  before_filter :disable_client_caching
  before_filter :check_route
  before_filter :remove_missionchange_flag
  before_filter :set_locale
  before_filter :get_mission
  before_filter :get_user
  before_action :prepare_exception_notifier
  before_filter :protect_admin_mode
  before_filter :remember_mission
  before_filter :remember_context, only: :index
  before_filter :load_settings_for_mission_into_config
  before_filter :load_accessible_missions

  helper_method :current_mode, :current_user, :current_mission, :current_root_path, :admin_mode?,
    :admin_mode_exit_path, :offline_mode?
end
