module AwesomeForms
  class AwesomeFormBuilder
    def input_list_open(field = nil, errors_field = nil)
      errors = nil
      label = nil
      popover = nil
      unless field.blank?
        errors = get_errors @object, errors_field if errors_field
        label = label field, nil
        popover = create_popover(@object_name, field)
      end
      @template.render partial: 'awesome/forms/input_list_open', locals:
        {
          label: label.to_s.html_safe,
          popover: popover.to_s.html_safe,
          errors: errors.to_s.html_safe
        }
    end

    # TODO: Use i18n for help of input list
    def input_list_close(field = nil, help = nil)
      unless field.blank?
        errors = get_errors @object, field
      else
        errors = nil
      end
      @template.render partial: 'awesome/forms/input_list_close', locals:
        {
          errors: errors.to_s.html_safe,
          help: help.to_s.html_safe
        }
    end
  end
end
