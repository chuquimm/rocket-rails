class ScaffoldServicesGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  argument :model, type: :string
  class_option :modules, type: :array, default: []
  class_option :languages, type: :array, default: ['es-PE']

  def gen_init
    set_dirs
    set_so_base_name
    set_names
    services.each { |service| init service }
    gen_locales
    template 'controller.template', @controller_path
    gen_views
  end

  private

  def set_dirs
    prefix = options.modules.join('/')
    prefix.empty?  ? nil : prefix
    @model_path = [prefix, model.pluralize.underscore].compact.join('/')
    @services_dir = ['app', 'services', @model_path].join('/')
    set_locales_dir
    @controller_path = ['app', 'controllers', "#{@model_path}_controller.rb"].join('/')
    @views_dir = ['app', 'views', @model_path].join('/')
  end

  def set_locales_dir
    @locales_active_record_dir = ['config', 'locales', 'activerecords', @model_path].join('/')
    @locales_controller_dir = ['config', 'locales', 'controllers', @model_path].join('/')
    @locales_views_dir = ['config', 'locales', 'views', @model_path].join('/')
  end

  def set_so_base_name
    @so_base_name = ''
    options.modules.each do |mod|
      @so_base_name += "#{mod.camelcase}::"
    end
  end

  def set_names
    base_name = ''
    options.modules.each do |mod|
      base_name += (mod.underscore + '_')
    end

    @plural_model_name = base_name + model.singularize.pluralize.underscore
    @singular_model_name = base_name + model.singularize.underscore
  end

  def services
    %w[create update destroy info query]
  end

  def init(service)
    template "#{service}.template", "#{@services_dir}/#{service}.rb"
  end

  def gen_locales
    options.languages.each do |language|
      @language = language
      template 'active_record_yml.template', "#{@locales_active_record_dir}/#{language}.yml"
    end
    template 'controller_yml/es_PE.template', "#{@locales_controller_dir}/es_PE.yml"
    template 'views_yml/es_PE.template', "#{@locales_views_dir}/es_PE.yml"
  end

  def gen_views
    views.each do |view|
      template "views/#{view}.template", "#{@views_dir}/#{view}.html.erb"
    end
  end

  def views
    %w[show]
  end
end
