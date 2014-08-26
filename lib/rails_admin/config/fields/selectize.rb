require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      class Selectize < RailsAdmin::Config::Fields::Association
        RailsAdmin::Config::Fields::Types.register(self)

        def association
          if relation_name
            bindings[:object].class.reflections[relation_name]
          else
            @properties
          end
        end

        register_instance_option :relation_name do
          nil
        end

        register_instance_option :visible? do
          true
        end

        register_instance_option :nested_form do
          {}
        end

        register_instance_option :partial do
          :form_selectize
        end

        register_instance_option :field_name do
          association.name.to_s.singularize + '_ids'
        end

        register_instance_option :search_url do
          parent_model_name = bindings[:object].class.name
          action = bindings[:controller].params[:action]
          "/rails-admin-selectize/search/#{ parent_model_name }/#{ method_name }/#{ action }"
        end

        register_instance_option :search_limit do
          20
        end

        register_instance_option :preload do
          true
        end

        register_instance_option :search_field do
          default_searchable_method
        end

        register_instance_option :search_text_field do
          default_searchable_method
        end

        register_instance_option :search_value_field do
          :id
        end

        register_instance_option :view_helper do
          :hidden_field
        end

        register_instance_option :allowed_methods do
          [field_name]
        end

        def default_searchable_method
          instance = association.klass.new

          [:title, :name].find do |searchable_method|
            instance.respond_to?(searchable_method)
          end
        end

        def serialized_value
          form_value.map do |item|
            {
              text: item.send(search_text_field),
              value: item.send(search_value_field)
            }
          end
        end

        def search_param
          :"q[#{ search_field }_cont]"
        end

        def parse_input(params)
          if (value = params[field_name]) && value.is_a?(String)
            params[field_name] = value.split(',')
          end
        end
      end
    end
  end
end
