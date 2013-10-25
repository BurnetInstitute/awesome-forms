module AwesomeForms
  class AwesomeFormBuilder

    # TODO: Use popover helper

    def image_upload (field, version = :thumbnail, *args)
      options = args.last.is_a?(Hash) ? args.pop : {} # Grab the options hash
      options_label = options.delete :label
      option_hide_errors = options.delete :hide_errors
      option_help = options.delete :help
      option_size = options.delete :size

      # Field
      if options[:class]
        options[:class] += ' form-control'
      else
        options[:class] = 'form-control'
      end

      option_size = 'col-lg-10' if ! option_size

      field_args = create_field_args args, options

      object_class = @object.class.name.constantize
      asset_base = object_class.new.respond_to?(:asset_base) ? object_class.new.asset_base : nil

      image = @template.image_tag(asset_base.to_s + @object.send(field).send(version).url)

      label = create_label field, nil, options_label

      field_html = file_field field, *field_args
      hidden_field_html = hidden_field "#{field}_cache"

      # Help text
      help = I18n.t("awesome.forms.help.#{@object_name}.#{field}", default: '').presence

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
        size: option_size,
        image: image.to_s.html_safe,
        field: field_html.to_s.html_safe,
        hidden_field: hidden_field_html.to_s.html_safe,
        errors: errors.to_s.html_safe,
        help: help.to_s.html_safe
      }
    end
  end
end
