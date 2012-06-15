module AwesomeForms
  class AwesomeFormBuilder

    def collection_radio_button(field, collection, label_option, *args)
      options = args.last.is_a?(Hash) ? args.pop : {} # Grab the options hash
      options_label = options.delete :label

      # Field
      field_args = create_field_args args, options
      fields_html = ''

      partial = __method__

      collection.each do |c|
        fields_html += @template.render partial: "awesome/forms/#{partial}_field", locals:
        {
          label: create_label(field, {option: c.send(label_option).underscore, plain: true}).to_s.html_safe,
          field: @template.radio_button_tag("#{@object_name}[#{field.to_s}][]", c.id, @object.send('has_'+field.to_s+'?', c.id), *field_args).to_s.html_safe
        }
      end
      @template.render partial: "awesome/forms/#{partial}", locals:
      {
        fields: fields_html.to_s.html_safe
      }
    end

  end
end
