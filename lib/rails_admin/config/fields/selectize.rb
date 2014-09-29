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
            @properties.association
          end
        end

        def collection?
          @collection ||= if relation_name
            bindings[:object].class.reflections[relation_name].collection?
          else
            @properties.association.collection?
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

        register_instance_option :creatable do
          false
        end

        register_instance_option :partial do
          :form_selectize
        end

        register_instance_option :inline_add do
          true
        end

        register_instance_option :field_name do
          association.name.to_s.singularize + '_ids'
        end

        register_instance_option :search_url do
          parent_model_name = bindings[:object].class.name
          action = bindings[:controller].params[:action]

          [
            '/rails-admin-selectize/search',
            parent_model_name,
            method_name,
            action
          ].join('/')
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

        def field_value
          if collection?
            form_value.map { |item| item.send(search_value_field) }.join(',')
          else
            form_value.send(search_value_field)
          end
        end

        def serialized_value
          if collection?
            form_value.map do |item|
              {
                text: item.send(search_text_field),
                value: item.send(search_value_field)
              }
            end
          else
            {
              text: form_value.send(search_text_field),
              value: form_value.send(search_value_field)
            }
          end
        end

        def search_param
          :"q[#{ search_field }_cont]"
        end

        def parse_input(params)
          if collection? && (value = params[field_name]) && value.is_a?(String)
            params[field_name] = value.split(',')
          end
        end
      end
    end
  end
end
