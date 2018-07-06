class Plugins::CamaleonPagenotfound::AdminController < CamaleonCms::Apps::PluginsAdminController
  include Plugins::CamaleonPagenotfound::MainHelper

  def index
  end

  # show settings form
  def settings
  end

  # save values from settings form
  def save_settings
    options = PAGENOTFOUND_DEFAULTS.merge(params[:options]&.to_unsafe_h.presence || {})
    @plugin.set_options(options) # save option values
    @plugin.set_metas(params[:metas]) if params[:metas].present? # save meta values
    @plugin.set_field_values(params[:field_options]) if params[:field_options].present? # save custom field values
    Rails.cache.delete_matched('pagenotfound_')
    redirect_to url_for(action: :settings), notice: 'Settings Saved Successfully'
  end
  # add custom methods below ....
end
