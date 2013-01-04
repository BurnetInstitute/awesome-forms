module AwesomeForms
  class AwesomeFormBuilder

    def collection_check_box(field, collection, label_text_method, value_method, *args)
      label_text_method_array = label_text_method.split '.'
      value_method_array = value_method.split '.'

      # Field
      fields_html = ''

      partial = __method__

      collection.each do |c|
        label_text = label_text_method_array.inject(c) {|result, method| result.send method}
        value = value_method_array.inject(c) {|result, method| result.send method}
        fields_html += @template.render partial: "awesome/forms/#{partial}_field", locals:
        {
          label: create_label(field, label_text, {plain: true}).to_s.html_safe,
          field: @template.check_box_tag("#{@object_name}[#{field.to_s}][]", value, @object.send('has_'+field.to_s.singularize+'?', value), *args).to_s.html_safe
        }
      end
      @template.render partial: "awesome/forms/#{partial}", locals:
      {
        fields: fields_html.to_s.html_safe
      }
    end

  end
end
