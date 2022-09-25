![Modern geoSystems logo](https://github.com/modgeosys/bulma_form_rails/blob/8fde36bf59e86254cfe9e792f395caba6f60a2a4/doc/images/moderngeosystems_logo.png?raw=true)
# bulma_form_rails
`bulma_form_rails` provides Rails helpers for efficiently building forms using the Bulma CSS library.

## Features

### Standard fields with default or custom labels, standard and optional CSS classes
* `bulma_input` with all `type` options
* `bulma_text_area`
* `bulma_checkbox`
* `bulma_radio_group` defines *all* radio options with a single call
* `bulma_select`
* `bulma_date_select`
* `bulma_time_select`
* `bulma_datetime_select`

### Custom and aggregate fields
* `bulma_custom_field` with a standard field label and custom markup passed in a block
* `bulma_child_objects` creates a "field" with a label and an editable subform for a collection of objects, including options for column totals and row add/delete buttons

### Message boxes
* `bulma_message_box` renders a standard flash messages box
* `bulma_validation_box` renders a standard model validation messages box

### Headers and footers
* `bulma_index_header` renders a header for a standard index page
* `bulma_form_footer` renders a footer for a standard model form page

### Form page template helpers
* `bulma_new_form_page`
* `bulma_edit_form_page`

## Prerequisites
You should have generated your application using something similar to the following command:
```bash
$ rails new -c bulma app_name
```
Or for an existing application, you should install Bulma as the Rails application generator would have.  Something like this might be enough:
```bash
$ yarn add bulma
```

## Installation
Install the gem and add to the application's Gemfile by executing:
```bash
$ bundle add bulma_form_rails
```
Or install it yourself as:
```bash
$ gem install bulma_form_rails
```
Continue your installation by executing:
```bash
$ bin/rails bulma_form_rails:install
$ bin/rails generate bulma_form_rails:pagy_config
$ bin/rails generate bulma_form_rails:views
```
`rails bulma_form_rails:install` will add required resources to your application.
The Rails generators will create your initial implementation view and configuration templates.  If you modify the generated files, you might not want to to run these generators again.

The final installation step is to manually `include Pagy::Backend` in your ApplicationController definition and `include Pagy::Frontend` in your ApplicationHelper module definition.

## Examples
(for a hypothetical user management UI)

### Sample `index.html.erb` page
```html
<section class="section">
  <%= bulma_index_header :user, new_user_path(page: params[:page]) %>
  <!-- Your index action content goes here. -->
  <%= pagy_bulma_nav(@pagy) %>
</section>
```

### Sample `new.html.erb` page
```html
<%= bulma_new_form_page :user, @user, users_path(page: params[:page]) %>
```

### Sample `edit.html.erb` page
```html
<%= bulma_edit_form_page :user, @user, users_path(page: params[:page]), user_path(page: params[:page]) %>
```

### Sample `_form.html.erb` partial
```html
<%= form_with model: user, url: url do |form| %>
  <%= bulma_validation_box user %>
  
  <fieldset id="basic_fields" class="box">
    <legend>Basic User Information</legend>

    <%= bulma_input form, :username, :text, class: 'is-danger' %>

    <%= bulma_custom_field(form, :password) do %>
      <div class="field">
        <div class="control">
          <%= password_field_tag 'user[password]', user.password, class: 'input is-danger' %>
        </div>
      </div>
    <% end %>

    <%= bulma_custom_field(form, :confirmed_password) do %>
      <div class="field">
        <div class="control">
          <%= password_field_tag 'user[confirmed_password]', user.confirmed_password, class: 'input is-danger' %>
        </div>
      </div>
    <% end %>

    <%= bulma_check_box form, :login_allowed, label: 'Login allowed?' %>
    <%= bulma_select form, :role_id, selectable_roles(@session_role), class: 'is-danger' %>
	<%= bulma_radio_group form, :role, [['Administrator', :admin], ['Regular user', :regular]], class: 'has-text-danger' %>
    
  </fieldset>

  <fieldset id="person_fields" class="box">
    <legend>Personal Information</legend>
    
    <%= form.fields_for :person do |person_subform| %>
      <%= bulma_input person_subform, :first_name, :text, class: 'is-danger' %>
      <%= bulma_input person_subform, :middle_name %>
      <%= bulma_input person_subform, :last_name, :text, class: 'is-danger' %>
      <%= bulma_input person_subform, :home_phone, :phone %>
      <%= bulma_input person_subform, :work_phone, :phone %>
      <%= bulma_input person_subform, :work_extension %>
      <%= bulma_input person_subform, :mobile_phone, :phone %>
      <%= bulma_input person_subform, :email_address, :email %>
	  <%= bulma_child_objects(relatives || [], 'relatives', :relative, users_add_child_path, total_columns: [3, 4]) %>
      
      <fieldset id="address_fields" class="box">
        <legend>Address</legend>
        
        <%= person_subform.fields_for :address do |address_subform| %>
          <%= bulma_text_area address_subform, :street_address, cols: 40, rows: 5 %>
          <%= bulma_input address_subform, :city %>
          <%= bulma_select address_subform, :state_id, State.all.order(:name).collect {|state| [state.name, state.id]}, include_blank: true %>
          <%= bulma_input address_subform, :zip_or_postal_code %>
          <%= bulma_select address_subform, :country, ["United States"] %>
        <% end %>
        
      </fieldset>
      
    <% end %>
    
  </fieldset>

  <%= bulma_form_footer form, users_path(page: params[:page]) %>
<% end %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/modgeosys/bulma_form_rails.

## License
The gem is available as open source under the terms of the [BSD 3-Clause License](https://opensource.org/licenses/BSD-3-Clause).