class InitServicesGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  
  argument :model, type: :string
  class_option :modules, type: :array, default: []

  def gen_init
    set_services_dir
    init_crud_services
  end

  private

  def set_services_dir
    @services_dir = services_dir
  end

  def services_dir
    ['app', 'services', *[options.modules], model.pluralize.underscore].join('/')
  end

  def init_crud_services
    services.each { |service| init service }
  end

  def init(service)
    template "#{service}.template", "#{@services_dir}/#{service}.rb"
  end

  def services
    %w[create update destroy info query]
  end
end

