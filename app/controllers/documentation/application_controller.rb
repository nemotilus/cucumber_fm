class Documentation::ApplicationController < ActionController::Base
  layout '/documentation/layouts/cucumber_fe'

  before_filter :digest_authenticate
  before_filter :save_config

  private

  def feature_dir_path
    git_dir_path.join('features')
  end

  def git_dir_path
    Rails.root
  end

  def save_config
    if params.has_key?(:config)
      cookies[:config] = params[:config].to_json
    elsif cookies[:config].nil?
      cookies[:config] = {}.to_json
    end
  end

  def read_config
    JSON.parse(cookies[:config])
  end

  def digest_authenticate
    unless session[:__documentation__authentication]
      session[:__documentation__authentication] = authenticate_or_request_with_http_digest("Documentation") do |username, password|
        username == 'some_app_name' && password == 'some_app_password'
      end
    end
  end
end