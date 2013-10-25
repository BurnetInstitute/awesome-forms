module AwesomeForms
  class AwesomeFormBuilder
    alias_method :super_check_box, :check_box

    def check_box(field, *args)
      options = args.last.is_a?(Hash) ? args.pop : {} # Grab the options hash
      option_checked_value = options.delete :checked_value
      option_unchecked_value = options.delete :unchecked_value

      field_args = create_field_args args, options

      option_checked_value ||= '1'
      option_unchecked_value ||= '0'

      field_html = super field, *field_args, option_checked_value, option_unchecked_value

      partial = __method__
      @template.render partial: "awesome/forms/#{partial}", locals:
      {
        label: create_label(field, nil, {plain: true}).to_s.html_safe,
        field: field_html.to_s.html_safe,
      }
    end
  end
end
