module AwesomeForms
  class AwesomeFormBuilder
    def error
      unless @object.errors.blank?
        @template.render partial: 'awesome/forms/error'
      end
    end

    def sub_error(field)
      errors = get_errors(@object, field)
      unless errors.blank?
        @template.render partial: 'awesome/forms/sub_error', locals: { errors: errors.to_s.html_safe }
      end
    end
  end
end
