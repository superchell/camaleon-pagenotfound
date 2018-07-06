require 'plugin_routes'
require 'camaleon_cms/engine'
Rails.application.routes.draw do
  scope PluginRoutes.system_info["relative_url_root"] do
    scope '(:locale)', locale: /#{PluginRoutes.all_locales}/, :defaults => {  } do
      # frontend
      namespace :plugins do
        namespace 'camaleon_pagenotfound' do
          get 'index' => 'front#index'
        end
      end
    end

    #Admin Panel
    scope :admin, as: 'admin', path: PluginRoutes.system_info['admin_path_name'] do
      namespace 'plugins' do
        namespace 'camaleon_pagenotfound' do
          controller :admin do
            get :index
            get :settings
            post :save_settings
          end
        end
      end
    end

    # main routes
    #scope 'camaleon_pagenotfound', module: 'plugins/camaleon_pagenotfound/', as: 'camaleon_pagenotfound' do
    #  Here my routes for main routes
    #end
  end
end
require 'plugin_routes'
require 'camaleon_cms/engine'
Rails.application.routes.draw do
  scope PluginRoutes.system_info["relative_url_root"] do
    scope '(:locale)', locale: /#{PluginRoutes.all_locales}/, :defaults => {  } do
      # frontend
      namespace :plugins do
        namespace 'camaleon_pagenotfound' do
          get 'index' => 'front#index'
        end
      end
    end

    #Admin Panel
    scope :admin, as: 'admin', path: PluginRoutes.system_info['admin_path_name'] do
      namespace 'plugins' do
        namespace 'camaleon_pagenotfound' do
          controller :admin do
            get :index
            get :settings
            post :save_settings
          end
        end
      end
    end

    # main routes
    #scope 'camaleon_pagenotfound', module: 'plugins/camaleon_pagenotfound/', as: 'camaleon_pagenotfound' do
    #  Here my routes for main routes
    #end
  end
end
