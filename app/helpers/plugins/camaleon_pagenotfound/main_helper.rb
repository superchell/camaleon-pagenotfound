module Plugins::CamaleonPagenotfound::MainHelper

  PAGENOTFOUND_DEFAULTS = {
    post_types: [],
    post_type_posts_list: [],
    category_list: [],
    category_posts_list: [],
    posts_list: [],
    tags: false,
  }.freeze

  def self.included(klass)
    # klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
  end

  # here all actions on going to active
  # you can run sql commands like this:
  # results = ActiveRecord::Base.connection.execute(query);
  # plugin: plugin model
  def camaleon_pagenotfound_on_active(plugin)
  end

  # here all actions on going to inactive
  # plugin: plugin model
  def camaleon_pagenotfound_on_inactive(plugin)
  end

  # here all actions to upgrade for a new version
  # plugin: plugin model
  def camaleon_pagenotfound_on_upgrade(plugin)
  end

  # hook listener to add settings link below the title of current plugin (if it is installed)
  # args: {plugin (Hash), links (Array)}
  # permit to add unlimmited of links...
  def camaleon_pagenotfound_on_plugin_options(args)
    args[:links] << link_to('Settings', admin_plugins_camaleon_pagenotfound_settings_path)
  end

  # hook listener to generate 404 pages, if the current page is in the list for an exception
  def custom_render_not_found
    post_types = []
    categories = []
    posts = []

    PAGENOTFOUND_DEFAULTS.keys.each do |option|
      next if option.to_s == 'tags'
      slugs = get_pagenotfound_slugs(option.to_s)
      post_types = post_types | slugs[:post_types] if slugs[:post_types].present?
      categories = categories | slugs[:categories] if slugs[:categories].present?
      posts = posts | slugs[:posts] if slugs[:posts].present?
    end

    self.render_page_not_found if request.path == "/index.html" ||
                                  params[:action] == 'post_type' && post_types.include?(params['post_type_slug']) ||
                                  params[:action] == 'post' && posts.include?(params[:slug]) ||
                                  params[:action] == 'category' &&  get_pagenotfound_option('category_list').include?(params[:category_id].to_i)
  end

  def pagenotfound_customize_sitemap(args)
    args[:skip_posttype_ids] += get_pagenotfound_option('post_types')
    args[:skip_posttype_ids].each do |ptype|
      args[:skip_post_ids] += current_site.the_posts(ptype).map(&:id)
      args[:skip_cat_ids] += current_site.the_categories(ptype).map(&:id)
    end

    args[:skip_posttype_ids] += current_plugin.get_option('post_type_posts_list')&.map(&:to_i).presence || []
    args[:skip_cat_ids]      += get_pagenotfound_option('category_list')
    args[:skip_post_ids]      += category_posts_list
    args[:skip_cat_ids]      += category_children
    args[:skip_tag_ids]      += current_site.the_tags.map(&:id) if current_plugin.get_option('tags')
    args[:skip_post_ids]     += get_pagenotfound_option('posts_list')
  end


  private


  def get_pagenotfound_slugs(option_key)
    ids = get_pagenotfound_option(option_key)
    return {} unless ids.present?

    Rails.cache.fetch("pagenotfound_slugs_#{I18n.locale.to_s}_#{option_key}") do
      res = {}
      case option_key
        when 'post_types'
          res[:post_types] = post_type_slugs(ids)
          res[:posts] = post_slugs(ids)
          res[:categories] = []
          ids.each do |post_type_id|
            res[:categories] += current_site.the_categories(post_type_id).map(&:slug).presence || []
          end
        when 'post_type_posts_list'
          res[:post_types] = post_type_slugs(ids)
        when 'category_list'
          res[:categories] = category_slugs(ids)
        when 'category_posts_list'
          categories = CamaleonCms::Category.where("id in (#{ids.join(',')})")
          res[:posts] = []
          res[:categories] = []
          categories.each do |category|
            res[:posts] += category.decorate.the_posts.map{|p| p.slug.translate}.presence || []
            res[:categories] += category.children.map(&:slug).presence || []
          end
        when 'posts_list'
          res[:posts] = post_slugs(ids)
        else
          nil
      end
      res
    end
  end

  def get_pagenotfound_option(option_key)
    Rails.cache.fetch("pagenotfound_#{option_key}") do
      current_plugin.get_option(option_key)&.map(&:to_i)
    end
  end

  def post_type_slugs(ids)
    CamaleonCms::PostType.where("id in (#{ids.join(',')})").map(&:slug).presence || []
  end

  def category_slugs(ids)
    CamaleonCms::Category.where("id in (#{ids.join(',')})").map(&:slug).presence || []
  end

  def post_slugs(ids)
    CamaleonCms::Post.where("taxonomy_id in (#{ids.join(',')})").map{|p| p.slug.translate}.presence || []
  end

  def category_posts_list
    posts_ids = []
    ids = get_pagenotfound_option('category_posts_list')
    categories = CamaleonCms::Category.where("id in (#{ids.join(',')})")
    categories.each{|category| posts_ids += category.decorate.the_posts.map(&:id).presence || []}
    posts_ids
  end

  def category_children
    cat_ids = []
    ids = get_pagenotfound_option('category_posts_list')
    categories = CamaleonCms::Category.where("id in (#{ids.join(',')})")
    categories.each{|category| cat_ids += category.children.map(&:slug).presence || []}
    cat_ids
  end
end
