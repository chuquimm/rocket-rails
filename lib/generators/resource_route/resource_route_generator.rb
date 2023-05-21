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

        create_route_file
        mods = Array(regular_class_path)
        insert_extend_route('config/routes.rb', main_route_class_name) unless mods.size.positive?

        for i in 0..(mods.size-1)
          selected_mods = mods[0, mods.size - i]
          mod_routes = "#{selected_mods.map(&:camelcase).join(':')}Routes"
          log mod_routes
        end
      end

      private

      def insert_extend_route(file_path, class_name, indentation: 2)
        inject_into_file file_path, before: 'end' do
          rebase_indentation("extend #{class_name}\n", indentation)
        end
      end

      def main_route_class_name
        "#{[regular_class_path, file_name.pluralize.camelcase].flatten.map(&:camelcase).join('::')}Routes"
      end

      def create_route_file
        @route_class_name = main_route_class_name
        template 'route.template', route_path
        return if behavior == :revoke

        route "resources :#{file_name.pluralize}", namespace: regular_class_path
      end

      # Original: https://github.com/rails/rails/blob/ef04fbb3b256beececfa44c47c4ec93ac6945e59/railties/lib/rails/generators/rails/resource_route/resource_route_generator.rb
      # Modified: use a method (route_path) instead of 'config/routes.rb'
      # Make an entry in Rails routing file <tt>config/routes.rb</tt>
      #
      #   route "root 'welcome#index'"
      #   route "root 'admin#index'", namespace: :admin
      def route(routing_code, namespace: nil)
        namespace = Array(namespace)
        routing_code = namespace.reverse.reduce(routing_code) do |code, name|
          "namespace :#{name} do\n#{rebase_indentation(code, 2)}end"
        end

        log :route, routing_code

        in_root do
          routing_code = rebase_indentation(routing_code, 6)

          inject_into_file route_path, routing_code, after: "router.instance_exec do\n", verbose: false, force: false
        end
      end

      def route_path
        dir = ['config', 'routes', regular_class_path].join('/')
        "#{dir}/#{file_name.pluralize.underscore}_routes.rb"
      end
    end
  end
end

