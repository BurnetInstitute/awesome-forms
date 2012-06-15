module AwesomeForms
  class AwesomeFormBuilder
    def link_to_remove_fields(name, options = {})
      hidden_field(:_destroy) + @template.link_to_function(name, "awesome_forms_remove_fields(this)", options)
    end

    def link_to_add_fields(name, association, association_object, partial, locals = {}, options = {})
      fields = fields_for association, association_object, child_index: "new_#{association}" do |form|
        locals.merge!({form: form})
        @template.render partial: partial, locals: locals
      end
      link = @template.link_to_function name.html_safe, "awesome_forms_add_fields(this, \"#{association}\", \"#{@template.escape_javascript(fields)}\")", options
      link = '<div class="awesome-forms-group">' + link + '</div>'
      link.html_safe
    end
  end
end
