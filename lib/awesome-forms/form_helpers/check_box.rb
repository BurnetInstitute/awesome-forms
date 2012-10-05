module AwesomeForms
  class AwesomeFormBuilder
    alias_method :super_check_box, :check_box

    def check_box(field, *args)
      options = args.last.is_a?(Hash) ? args.pop : {} # Grab the options hash
      option_checked_value = options.delete :checked_value
      option_unchecked_value = options.delete :unchecked_value
      options_label = options.delete :label
      option_hide_errors = options.delete :hide_errors

      # Field
      field_args = create_field_args args, options

      option_checked_value ||= '1'
      option_unchecked_value || '0'

      field_html = super field, *field_args, option_checked_value, option_unchecked_value

      # Check box fields nested inside label
      if options_label.present?
        options_label.merge! class: 'checkbox', before: field_html
      else
        options_label = { class: 'checkbox', before: field_html }
      end

      partial = __method__
      @template.render partial: "awesome/forms/#{partial}", locals:
      {
        label: create_label(field, nil, options_label).to_s.html_safe,
        popover: create_popover(@object_name, field).to_s.html_safe,
        field: field_html.to_s.html_safe,
        errors: get_errors(@object, field, option_hide_errors).to_s.html_safe,
        help: get_help_text(@object_name, field).to_s.html_safe
      }
    end
  end
end
