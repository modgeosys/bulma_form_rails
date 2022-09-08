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

### Custom and composite fields
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

## Installation
Add this line to your application's Gemfile:
```
gem 'bulma_form_rails`
```
And then execute:
```
bundle
```
Or install it yourself as:
```
gem install bulma_form_rails
```

## Examples
(for a hypothetical user management UI)

### Sample `index.html.erb` page
```
<section class="section">
  <%= bulma_index_header :user, new_user_path(page: params[:page]) %>
  <!-- Your index action content goes here. -->
  <%== pagy_bulma_nav(@pagy) %>
</section>
```

### Sample `new.html.erb` page
```
<%= bulma_new_form_page :user, @user, users_path(page: params[:page]) %>
```

### Sample `edit.html.erb` page
```
<%= bulma_edit_form_page :user, @user, users_path(page: params[:page]), user_path(page: params[:page]) %>
```

### Sample `_form.html.erb` partial
```
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

## License
The gem is available as open source under the terms of the [BSD 3-Clause License](https://opensource.org/licenses/BSD-3-Clause).