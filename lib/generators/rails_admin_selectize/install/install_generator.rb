module RailsAdminSelectize
  class InstallGenerator < Rails::Generators::Base
    # Copied files come from templates folder
    source_root File.expand_path('../templates', __FILE__)

    # Generator desc
    desc "Rails Admin Selectize install generator"

    def mount_engine
      mount_path = ask(
        "Where would you like to mount Rails Admin Selectize engine ? [/rails-admin-selectize]"
      ).presence || '/rails-admin-selectize'
      mount_path = mount_path.match(/^\//) ? mount_path : "/#{ mount_path }"

      gsub_file "config/routes.rb", /mount RailsAdminSelectize.*\n/, ''

      route "mount RailsAdminSelectize::Engine => '#{ mount_path }', as: 'rails_admin_selectize'"
    end

    def require_javascript
      folder = Rails.root.join(*%w{app assets javascripts rails_admin custom})

      existing_file = [
        folder.join('ui.js.coffee'),
        folder.join('ui.coffee'),
        folder.join('ui.js')
      ].find(&File.method(:exist?))

      if existing_file
        existing_file = existing_file.to_s
        mode = existing_file.match(/\.js$/) ? :js : :coffee

        gsub_file(
          existing_file,
          /\A/,
          sprockets_require('rails_admin_selectize', mode)
        )
      else
        create_file(
          'assets/javascripts/rails_admin/custom/ui.js.coffee',
          sprockets_require('rails_admin_selectize', mode)
        )
      end
    end

    private

    def sprockets_require(file, mode = :coffee)
      case mode
      when :coffee then "#= require #{ file }\n"
      when :js then "//= require #{ file }\n"
      end

    end
  end
end
