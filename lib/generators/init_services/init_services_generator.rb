class InitServicesGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  argument :model, type: :string
  class_option :modules, type: :array, default: []
  class_option :languages, type: :array, default: ['es-PE']

  def gen_init
    set_dirs
    services.each { |service| init service }
    options.languages.each { |language| create_locales language }
  end

  private

  def set_dirs
    set_services_dir
    set_locales_dir
  end

  def set_services_dir
    @services_dir = services_dir
  end

  def services_dir
    ['app', 'services', modules_prefix_dir, model.pluralize.underscore].compact.join('/')
  end

  def set_locales_dir
    @locales_dir = locales_dir
  end

  def locales_dir
    ['config', 'locales', 'activerecords', modules_prefix_dir, model.pluralize.underscore].compact.join('/')
  end

  def modules_prefix_dir
    prefix = ''
    prefix = options.modules.join('/')
    prefix.empty?  ? nil : prefix
  end

  def init(service)
    template "#{service}.template", "#{@services_dir}/#{service}.rb"
  end

  def create_locales(language)
    @language = language
    template 'active_record_yml.template', "#{@locales_dir}/#{language}.yml"
  end

  def services
    %w[create update destroy info query]
  end
end

