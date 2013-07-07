[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/wwidea/composable_builders)

ComposableBuilders
==================

A series of modules that can be combined together to create a customized FormBuilder class.


Example
=======

    <% form_for @post, :builder => ComposableBuilder(:tagged => true, :printable => true) do |form| %>
      <%= form.text_field :title %>
      <%= form.text_area :body %>
      <%= form.submit %>
    <% end %>


Copyright (c) 2009 WWIDEA, released under the MIT license
