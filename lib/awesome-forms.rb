require 'awesome-forms/engine'

# Remove the field_with_errors div that rails generates.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| html_tag end

module AwesomeForms
  class AwesomeFormBuilder < ActionView::Helpers::FormBuilder
  end
end

require 'awesome-forms/form_helpers/basic'
require 'awesome-forms/form_helpers/button'
require 'awesome-forms/form_helpers/check_box'
require 'awesome-forms/form_helpers/collection_check_box'
require 'awesome-forms/form_helpers/collection_radio_button'
require 'awesome-forms/form_helpers/dynamic'
require 'awesome-forms/form_helpers/error'
require 'awesome-forms/form_helpers/image_upload'
require 'awesome-forms/form_helpers/input_list'
require 'awesome-forms/form_helpers/label'

require 'awesome-forms/helpers/helpers'

ActionView::Base.default_form_builder = AwesomeForms::AwesomeFormBuilder # Make AwesomeForms the default form builder
