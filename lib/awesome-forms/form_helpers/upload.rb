module AwesomeForms
  class AwesomeFormBuilder
    def upload (field, *args)

      options = args.last.is_a?(Hash) ? args.pop : {} # Grab the options hash
      options_label = options.delete :label
      option_hide_errors = options.delete :hide_errors
      option_size = options.delete :size

      # Recreate the argument list with the possibly modified options hash
      if options[:class]
        options[:class] += ' form-control'
      else
        options[:class] = 'form-control'
      end

      option_size = 'col-lg-10' if ! option_size

      field_args = Array[options] if args.blank?
      field_args = args if args.present?
      if args and options
        field_args = args
        field_args << options
      end
      object_class = @object.class.name.constantize
      asset_base = object_class.new.respond_to?(:asset_base) ? object_class.new.asset_base : nil

      if @object.send "#{field}?"
        file_name = @object.send(field).file.filename
        file_url = @object.send(field).url
      else
        file_name =''
        file_url = ''
      end

      label = create_label field, nil, options_label

      field_html = file_field field, *field_args

      # Popovers
      popover = nil
      popover_data_original_title = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.title", default: I18n.t("activerecord.attributes.#{@object_name}.#{field}")).presence
      popover_data_content = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.content", default: '').presence
      unless popover_data_content.blank?
        popover = "rel=\"popover\" data-original-title=\"#{popover_data_original_title}\" data-content=\"#{popover_data_content}\""
      end

      errors = get_errors @object, field, option_hide_errors

      partial = __method__
      @template.render partial: "awesome/forms/#{partial}", locals:
      {
        label: label.to_s.html_safe,
        popover: popover.to_s.html_safe,
        file_name: file_name.html_safe,
        file_url: file_url.html_safe,
        size: option_size,
        field: field_html.to_s.html_safe,
        errors: errors.to_s.html_safe,
        help: get_help_text(@object_name, field).to_s.html_safe
      }
    end
  end
end
