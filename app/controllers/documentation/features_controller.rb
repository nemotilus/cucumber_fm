class Documentation::FeaturesController < Documentation::ApplicationController

  before_filter :fetch_feature, :only => [:show, :edit, :update]
  before_filter :cleanup_raw, :only => [:update]

  def index
    @highlight = 'business_overview'
    cfm
  end

  def show
  end

  def edit
  end

  def create
    feature = CucumberFM::Feature.new(new_file_path, cfm)
    feature.raw=(new_feature_raw)
    feature.save
    redirect_to edit_documentation_feature_path(feature.id)
  end

  def update
    @feature.raw=(params[:raw])
    @feature.save
    redirect_to :action => :edit
  end

  private

  def fetch_feature
    @feature = CucumberFM::Feature.new(path, cfm)
  end

  def path
    File.join(cfm.path, Base64.decode64(params[:id]))
  end

  def cfm
    @cfm ||= CucumberFeatureManager.new(feature_dir_path, git_dir_path, read_config)
  end

  def cleanup_raw
    params[:raw].gsub!(/\r/, '')
  end

  def new_file_path
    if read_config['dir']
      File.join(feature_dir_path, read_config['dir'], "#{new_file_name}.feature")
    else
      File.join(feature_dir_path, "#{new_file_name}.feature")
    end
  end

  def new_file_name
    params[:name].gsub(/[^a-zA-Z0-9]/, '_')
  end

  def new_file_feature_name
    params[:name].gsub(/(_|\.feature)/, ' ')
  end

  def new_feature_raw
    %{Feature: #{new_file_feature_name}}
  end

end