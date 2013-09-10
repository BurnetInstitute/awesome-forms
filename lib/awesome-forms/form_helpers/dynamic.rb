module AwesomeForms
  class AwesomeFormBuilder
    def link_to_remove_fields(name, options = {})
      if options[:class]
        options[:class] += ' awesome_forms_remove_fields'
      else
        options.merge!({class: 'awesome_forms_remove_fields'})
      end
      hidden_field(:_destroy) + @template.link_to(name.html_safe, '#', options)
    end

    def link_to_add_fields(name, association, partial, locals = {}, options = {})
      new_association_object = object.send(association).klass.new
      new_association_object_id = new_association_object.object_id
      fields = fields_for association, new_association_object, child_index: new_association_object_id do |form|
        locals.merge!({form: form})
        @template.render partial: partial, locals: locals
      end

      if options[:class]
        options[:class] += ' awesome_forms_add_fields'
      else
        options.merge!({class: 'awesome_forms_add_fields'})
      end

      if options[:data]
        options[:data].merge!({id: new_association_object_id, fields: fields.gsub("\n", "")})
      else
        options.merge!(data: {id: new_association_object_id, fields: fields.gsub("\n", "")})
      end

      @template.link_to name.html_safe, '#', options
    end
  end

  # def link_to_add_fields(name, f, association)
  #   new_object = f.object.send(association).klass.new
  #   id = new_object.object_id
  #   fields = f.fields_for(association, new_object, child_index: id) do |builder|
  #     render(association.to_s.singularize + "_fields", f: builder)
  #   end
  #   link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  # end
end
