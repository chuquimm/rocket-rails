# frozen_string_literal: true

module Rails
  module Generators
    class ResourceRouteGenerator < NamedBase # :nodoc:
      # Properly nests namespaces passed into a generator
      #
      #   $ bin/rails generate resource admin/users/products
      #
      # should give you
      #
      #   namespace :admin do
      #     namespace :users do
      #       resources :products
      #     end
      #   end
      def add_resource_route
        return if options[:actions].present?

        insert_basic_route
        create_route_file
      end

      private

      def insert_basic_route
        inject_into_file 'config/routes.rb', before: 'end' do
          "  extend #{route_class_name}\n"
        end
      end

      def route_class_name
        "#{[regular_class_path, file_name.pluralize.camelcase].flatten.map(&:camelcase).join('')}Routes"
      end

      def create_route_file
        dir = ['config', 'routes', regular_class_path].join('/')
        template 'route.template', "#{dir}/#{file_name.pluralize.underscore}_routes.rb"
        # TODO: usar el metodo 'route' que se usa por defecto en el generador, pero dentro del template.
        # route "resources :#{file_name.pluralize}", namespace: regular_class_path
      end
    end
  end
end

