module AwesomeForms
  class AwesomeFormBuilder
    # Private methods that are used in form_helpers
    private

      # Recreate the argument list with the possibly modified options hash for field args
      def create_field_args(args, options)
        field_args = Array[options] if args.blank?
        field_args = args if args.present?
        if args and options
          field_args = args
          field_args << options
        end
      end

      # Create the label if options_label doesn't contain :none
      def create_label(field, text = nil, options_label)
        if options_label and options_label[:none]
          label = ''
        else
          label = label field, text, options_label
        end
      end

      # Get help text from i18n
      def get_help_text(object_name, field)
        I18n.t("awesome.forms.help.#{object_name.tableize}.#{field}", default: '')
      end

      # Create popoever from i18n
      def create_popover(object_name, field)
        popover = ''
        popover_default_title = I18n.t("activemodel.attributes.#{object_name}.#{field}", default: "activerecord.attributes.#{object_name}.#{field}")
        popover_data_original_title = I18n.t("awesome.forms.popovers.#{object_name.tableize}.#{field}.title", default: popover_default_title).presence
        popover_data_content = I18n.t("awesome.forms.popovers.#{object_name.tableize}.#{field}.content", default: '').presence
        unless popover_data_content.blank?
            popover = "rel=\"popover\" data-original-title=\"#{popover_data_original_title}\" data-content=\"#{popover_data_content}\""
        end
      end

      # Get form errors for specific field seperated by br tags
      def get_errors(object, field, hide_errors = nil)
        object && hide_errors.blank? && object.errors[field] ? object.errors[field].join(@template.tag(:br)).html_safe : ''
      end
  end
end
