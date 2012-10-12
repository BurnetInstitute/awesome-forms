module AwesomeForms
  class AwesomeFormBuilder

    def collection_radio_button(field, collection, label_text_method, *args)
      # Field
      fields_html = ''

      partial = __method__

      collection.each do |c|
        fields_html += @template.render partial: "awesome/forms/#{partial}_field", locals:
        {
          label: create_label(field, c.send(label_text_method), {plain: true}).to_s.html_safe,
          field: @template.radio_button_tag("#{@object_name}[#{field.to_s}][]", c.id, @object.send('has_'+field.to_s.singularize+'?', c.id), *args).to_s.html_safe
        }
      end
      @template.render partial: "awesome/forms/#{partial}", locals:
      {
        fields: fields_html.to_s.html_safe
      }
    end

  end
end
