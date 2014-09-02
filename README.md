# Rails Admin Selectize

Adds a `:selectize` field type to Rails Admin that wraps
[selectize.js](http://brianreavis.github.io/selectize.js/) plugin.

It is mainly inteded to allow you to remotely load relation models in the
select box from the server, instead of loading them all on page load, but can
be tweaked to adapt to your needs.

The needed models are inferred from your model's relations and the field
you add the plugin to. But you can always override those assumptions to
make it work with your structure, e.g. with a tags field from
[acts-as-taggable-on](https://github.com/mbleigh/acts-as-taggable-on)

## Usage

Add the plugin to your Gemfile and bundle :

```ruby
gem 'rails_admin'
gem 'rails_admin_selectize', github: 'glyph-fr/rails_admin_selectize'
```

Use the generator to mount the engine in your routes and add the coffee plugin
to your `assets/javascripts/rails_admin/custom/ui.js.coffee` file:

```bash
rails generate rails_admin_selectize:install
```

In your model's `rails_admin` configuration, use the `:selectize` field type :

```ruby
class Publication < ActiveRecord::Base
  has_many :publication_categories
  has_many :categories, through: :publication_categories

  rails_admin
    field :categories, :selectize
  end
end
```

When creating or editing a `Publication`, you'll see a `selectize` field that
displays you the options loaded remotely.

## Configuration

You can configure the plugin with the following settings, which are given with
the value the would default to, given the previous `Publication` configuration
example :

```ruby
rails_admin
  field :categories, :selectize do
    # Defines the name of the relation to fetch data from
    relation_name :categories
    # Allows hiding the field
    visible? true
    # Allows creating items as tags : Will prompt "Add xxx..." when typing a
    # text that isn't in the search results
    creatable false
    # Defines the key used in the field [name] attribute
    field_name :category_ids
    # The URL to search the associated data in. It is generated dynamically and
    # you should only override it if you plan to provide your own controller
    # action to search and render the results
    search_url '/rails-admin-selectize/search/Publication/categories/<current-controller-action>'
    # The limit used in the search query
    search_limit 20
    # Defines if we want to preload some data when the selectize input is
    # focused for the first time
    preload true
    # Defines the field to be searched.
    # Since Ransack is used with the '_cont' suffix under the hood, you can
    # easily search multiple fields or on associated models
    # e.g. With globalize, you can us `search_field :translations_title`
    search_field :title
    # The method to call on the object to fetch its label when serializing it to
    # JSON. The default would be : { text: title, value: id }
    search_text_field :title
    # The method to call on the object to fetch its value when serializing it to
    # JSON. The default would be : { text: title, value: id }
    search_value_field :id
  end
end
```

## Licence

This project rocks and uses MIT-LICENSE.