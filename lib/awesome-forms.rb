require "awesome-forms/engine"

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| html_tag end # Remove the field_with_errors div that rails generates.

module AwesomeForms
	class AwesomeFormBuilder < ActionView::Helpers::FormBuilder

		basic_helpers = [:text_field, :password_field, :email_field, :text_area, :select, :check_box]
		#multipart_helpers = %w{date_select datetime_select}

		basic_helpers.each do |name|
			# Alias old method
			class_eval do
				alias_method 'super_#{name.to_s}'.to_sym, name
			end

			define_method(name) do |field, *args|
				options = args.last.is_a?(Hash) ? args.pop : {} # Grab the options hash
				option_rails = options.delete :rails
				options_label = options.delete :label
				option_hide_errors = options.delete :hide_errors
				option_help = options.delete :help
				unless option_rails.blank? # If rails is passed as option use the rails default rails form method
					return super
				end

				# Recreate the argument list with the possibly modified options hash
				field_args = Array[options] if args.blank?
				field_args = args if args.present?
				if args and options
					field_args = args
					field_args << options
				end

				field_html = super field, *field_args

				# Check box fields nested inside label
				if __method__ == :check_box
					if options_label.present?
						options_label << { before: field_html + '<span>'.html_safe, after: '</span>' }
					else
						options_label = { before: field_html + '<span>'.html_safe, after: '</span>' }
					end
				end

				label = label field, nil, options_label

				# Popovers
				popover = nil
				popover_data_original_title = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.title", default: I18n.t("activerecord.attributes.#{@object_name}.#{field}")).presence
				popover_data_content = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.content", default: '').presence
				unless popover_data_content.blank?
					popover = "rel=\"popover\" data-original-title=\"#{popover_data_original_title}\" data-content=\"#{popover_data_content}\"".html_safe
				end

				errors = get_errors @object, field, option_hide_errors

				partial = __method__
				@template.render partial: "awesome/forms/#{partial}", locals: {label: label, popover: popover, field: field_html, errors: errors, help: option_help}
			end
		end



		class_eval do
			alias_method :super_collection_select, :collection_select
		end

		define_method(:collection_select) do |field, collection, value_method, text_method, collection_select_options = {}, html_options = {}, *args|
			options = args.last.is_a?(Hash) ? args.pop : {} # Grab the options hash
			option_rails = options.delete :rails
			options_label = options.delete :label
			option_hide_errors = options.delete :hide_errors
			option_help = options.delete :help
			unless option_rails.blank? # If rails is passed as option use the rails default rails form method
				return super field, collection, value_method, text_method, collection_select_options, html_options
			end

			# Recreate the argument list with the possibly modified options hash
			field_args = Array[options] if args.blank?
			field_args = args if args.present?
			if args and options
				field_args = args
				field_args << options
			end

			field_html = super field, collection, value_method, text_method, collection_select_options, html_options

			label = label field, nil, options_label

			# Popovers
			popover = nil
			popover_data_original_title = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.title", default: I18n.t("activerecord.attributes.#{@object_name}.#{field}")).presence
			popover_data_content = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.content", default: '').presence
			unless popover_data_content.blank?
				popover = "rel=\"popover\" data-original-title=\"#{popover_data_original_title}\" data-content=\"#{popover_data_content}\"".html_safe
			end

			errors = get_errors @object, field, option_hide_errors

			partial = __method__
			@template.render partial: "awesome/forms/#{partial}", locals: {label: label, popover: popover, field: field_html, errors: errors, help: option_help}
		end

		alias_method :super_label, :label
		def label(method, text = nil, options = {}, &block)
			unless options
				options = {}
			end

			options[:class] = 'control-label' # For twitter bootstrap.

			option_rails = options.delete :rails
			option_value = options.delete :value
			option_plain = options.delete :plain
			option_before = options.delete :before
			option_after = options.delete :after

			option_before ||= ''
			option_after ||= ''

			unless option_rails.blank? # If rails is passed as option use the rails default rails label method
				return super
			end

			# Mostly from module ActionView::Helpers::InstanceTag.to_label_tag.
			# When a block is passed the text doesnt go through it's usual lookup code.
			# We still want to provide the text via I18n and keep expected lable behaviour.
			content = if text.blank?
				method_and_value = option_value.present? ? "#{method}.#{option_value}" : method
				I18n.t("helpers.label.#{@object_name}.#{method_and_value}", :default => '').presence
			else
				text.to_s
			end

			content ||= if @object && @object.class.respond_to?(:human_attribute_name)
				@object.class.human_attribute_name method
			end

			content ||= method.humanize

			# Help text
			sub_label = I18n.t("awesome.forms.labels.#{@object_name}.#{method}", default: '').presence
			unless sub_label.blank?
				content += @template.render partial: 'awesome/forms/sub_label', locals: {sub_label: sub_label}
				content = content.html_safe
			end

			if option_plain == true
				return content.html_safe
			else
				super do
					content = option_before.html_safe + content.html_safe + option_after.html_safe
				end
			end
		end

		def input_list_open(field = nil)
			unless field.blank?
				errors = get_errors @object, field
				label = label field, nil, {plain: true}
			else
				errors = nil
				label = nil
			end
			@template.render partial: 'awesome/forms/input_list_open', locals: {label: label, errors: errors}
		end

		def input_list_close(field = nil, help = nil)
			unless field.blank?
				errors = get_errors @object, field
			else
				errors = nil
			end
			@template.render partial: 'awesome/forms/input_list_close', locals: {errors: errors, help: help}
		end

		def error
			unless @object.errors.blank?
				@template.render partial: 'awesome/forms/error'
			end
		end

		def sub_error(field)
			errors = get_errors(@object, field)
			unless errors.blank?
				@template.render partial: 'awesome/forms/sub_error', locals: { errors: errors }
			end
		end

		def get_errors(object, field, hide_errors = nil)
			object && hide_errors.blank? && object.errors[field] ? object.errors[field].join(@template.tag(:br)).html_safe : ''
		end

		def cancel_button(redirect)
			@template.render partial: 'awesome/forms/cancel_button', locals: { redirect: redirect }
		end

		def link_to_remove_fields(name)
			self.hidden_field(:_destroy) + @template.link_to_function(name, "awesome_forms_remove_fields(this)")
		end

		def link_to_add_fields(name, association, association_object, partial)
			fields = self.fields_for association, association_object, child_index: "new_#{association}" do |form|
				@template.render partial: partial, object: form
			end
			name = '<div class="awesome-forms-group">' + name + '</div>'
			@template.link_to_function name.html_safe, "awesome_forms_add_fields(this, \"#{association}\", \"#{@template.escape_javascript(fields)}\")"
		end
	end
end

ActionView::Base.default_form_builder = AwesomeForms::AwesomeFormBuilder # Make AwesomeForms the default form builder
