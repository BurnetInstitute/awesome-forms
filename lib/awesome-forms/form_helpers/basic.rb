module AwesomeForms
  class AwesomeFormBuilder
    basic_helpers = [:text_field, :password_field, :email_field, :telephone_field, :text_area, :select, :collection_select, :radio_button]

    basic_helpers.each do |name|
      # Alias old method
      class_eval do
        alias_method "super_#{name.to_s}".to_sym, name
      end

      define_method(name) do |field, *args|

        options = args.last.is_a?(Hash) ? args.pop : {} # Grab the options hash
        options_label = options.delete :label
        option_hide_errors = options.delete :hide_errors
        option_size = options.delete :size

        # Field
        if options[:class]
          options[:class] += ' form-control'
        else
          options[:class] = 'form-control'
        end

        option_size = 'col-lg-10' if ! option_size

        field_args = create_field_args args, options
        field_html = super field, *field_args

        # Radio button fields nested inside label
        if __method__ == :radio_button
          if options_label.present?
            options_label.merge! class: 'radio', before: field_html
          else
            options_label = { class: 'radio', before: field_html }
          end
        end

        partial = __method__
        @template.render partial: "awesome/forms/#{partial}", locals:
        {
          label: create_label(field, nil, options_label).to_s.html_safe,
          popover: create_popover(@object_name, field).to_s.html_safe,
          size: option_size,
          field: field_html.to_s.html_safe,
          errors: get_errors(@object, field, option_hide_errors).to_s.html_safe,
          help: get_help_text(@object_name, field).to_s.html_safe
        }
      end
    end
  end
end
