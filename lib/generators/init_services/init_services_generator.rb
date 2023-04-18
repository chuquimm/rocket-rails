class InitServicesGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :modules, type: :array, default: []

  def gen_init
    assign_service_params
    services.each { |service| init service }
  end

  private

  def assign_service_params
    plural_name = name.pluralize
    @service_class_path = plural_name.include?('/') ? plural_name.split('/') : plural_name.split('::')
    @service_class_path.map!(&:underscore)
    @service_dir = @service_class_path.join('/')
    @service_dir = ['app', 'services', @service_class_path].flatten.compact.join('/')
    @service_module = @service_class_path.map(&:camelcase).join('::')
    set_service_model
  end

  def set_service_model
    @service_model = @service_class_path.map(&:camelcase)
    @service_model[-1] = file_name.camelcase
    @service_model = "::#{@service_model.join('::')}"
  end

  def init(service)
    template "#{service}.template", "#{@service_dir}/#{service}.rb"
  end

  def services
    %w[create update destroy info query]
  end
end

