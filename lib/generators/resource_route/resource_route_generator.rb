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

        # route "resources :#{file_name.pluralize}", namespace: regular_class_path
        insert_basic_route
        create_route_file
      end

      private

      def insert_basic_route
        inject_into_file 'config/routes.rb', before: 'end' do
          "  extend #{file_name.pluralize.capitalize}Routes\n"
        end
      end

      def create_route_file
        template 'route.template', "config/routes/#{file_name.pluralize.underscore}_routes.rb"
        # TODO: usar el metodo 'route' que se usa por defecto en el generador, pero dentro del template.
      end
    end
  end
end

