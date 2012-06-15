module AwesomeForms
  class AwesomeFormBuilder
    def cancel_button(redirect)
      label = I18n.t("helpers.cancel.#{@object_name}.#{@template.params[:action]}", :default => '').presence
      label ||= 'Cancel'
      @template.render partial: 'awesome/forms/cancel_button', locals: { label: label, redirect: redirect }
    end
  end
end
