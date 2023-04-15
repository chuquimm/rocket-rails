class InitServicesGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  argument :model, type: :string
  class_option :modules, type: :array, default: []
  class_option :languages, type: :array, default: ['es-PE']

  def gen_init
    set_dirs
    set_so_base_name
    services.each { |service| init service }
    options.languages.each { |language| create_locales language }
  end

  private

  def set_dirs
    prefix = options.modules.join('/')
    prefix.empty?  ? nil : prefix
    @services_dir = ['app', 'services', prefix, model.pluralize.underscore].compact.join('/')
    @locales_dir = ['config', 'locales', 'activerecords', prefix, model.pluralize.underscore].compact.join('/')
  end

  def set_so_base_name
    @so_base_name = ''
    options.modules.each do |mod|
      @so_base_name += "#{mod.camelcase}::"
    end
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

