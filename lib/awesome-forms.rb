require "awesome-forms/engine"

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| html_tag end # Remove the field_with_errors div that rails generates.

module AwesomeForms
	class AwesomeFormBuilder < ActionView::Helpers::FormBuilder

		basic_helpers = [:text_field, :password_field, :email_field, :text_area, :select, :check_box]
		# Custom helpers: collection_select, image_upload

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
						options_label << { class: 'checkbox', before: field_html }
					else
						options_label = { class: 'checkbox', before: field_html }
					end
				end

				if options_label and options_label[:none]
					label = ''
				else
					label = label field, nil, options_label
				end

				# Help text
				help = I18n.t("awesome.forms.help.#{@object_name}.#{field}", default: '')

				# Popovers
				popover = ''
				popover_data_original_title = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.title", default: I18n.t("activerecord.attributes.#{@object_name}.#{field}")).presence
				popover_data_content = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.content", default: '').presence
				unless popover_data_content.blank?
					popover = "rel=\"popover\" data-original-title=\"#{popover_data_original_title}\" data-content=\"#{popover_data_content}\""
				end

				errors = get_errors @object, field, option_hide_errors

				partial = __method__
				@template.render partial: "awesome/forms/#{partial}", locals:
					{
						label: label.to_s.html_safe,
						popover: popover.to_s.html_safe,
						field: field_html.to_s.html_safe,
						errors: errors.to_s.html_safe,
						help: help.to_s.html_safe
					}
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

			# Help text
			help = I18n.t("awesome.forms.help.#{@object_name}.#{field}", default: '').presence

			# Popovers
			popover = nil
			popover_data_original_title = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.title", default: I18n.t("activerecord.attributes.#{@object_name}.#{field}")).presence
			popover_data_content = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.content", default: '').presence
			unless popover_data_content.blank?
				popover = "rel=\"popover\" data-original-title=\"#{popover_data_original_title}\" data-content=\"#{popover_data_content}\""
			end

			errors = get_errors @object, field, option_hide_errors

			partial = __method__
			@template.render partial: "awesome/forms/#{partial}", locals:
				{
					label: label.to_s.html_safe,
					popover: popover.to_s.html_safe,
					field: field_html.to_s.html_safe,
					errors: errors.to_s.html_safe,
					help: help.to_s.html_safe
				}
		end

		def image_upload (field, version = :thumbnail, *args)
			options = args.last.is_a?(Hash) ? args.pop : {} # Grab the options hash
			options_label = options.delete :label
			option_hide_errors = options.delete :hide_errors
			option_help = options.delete :help

			# Recreate the argument list with the possibly modified options hash
			field_args = Array[options] if args.blank?
			field_args = args if args.present?
			if args and options
				field_args = args
				field_args << options
			end

			image = @template.image_tag @object.send(field).send(version).url

			label = label field, nil, options_label

			field_html = file_field field, *field_args
			hidden_field_html = hidden_field "#{field}_cache"

			# Help text
			help = I18n.t("awesome.forms.help.#{@object_name}.#{field}", default: '').presence

			# Popovers
			popover = nil
			popover_data_original_title = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.title", default: I18n.t("activerecord.attributes.#{@object_name}.#{field}")).presence
			popover_data_content = I18n.t("awesome.forms.popovers.#{@object_name}.#{field}.content", default: '').presence
			unless popover_data_content.blank?
				popover = "rel=\"popover\" data-original-title=\"#{popover_data_original_title}\" data-content=\"#{popover_data_content}\""
			end

			errors = get_errors @object, field, option_hide_errors

			partial = __method__
			@template.render partial: "awesome/forms/#{partial}", locals:
				{
					label: label.to_s.html_safe,
					popover: popover.to_s.html_safe,
					image: image.to_s.html_safe,
					field: field_html.to_s.html_safe,
					hidden_field: hidden_field_html.to_s.html_safe,
					errors: errors.to_s.html_safe,
					help: help.to_s.html_safe
				}
		end

		alias_method :super_label, :label
		def label(method, text = nil, options = {}, &block)
			unless options
				options = {}
			end

			options[:class] = 'control-label' unless options[:class]# For twitter bootstrap.

			option_rails = options.delete :rails
			option_value = options.delete :value
			option_plain = options.delete :plain
			option_before = options.delete :before
			option_after = options.delete :after

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

			# Sub label text
			sub_label = I18n.t("awesome.forms.labels.#{@object_name}.#{method}", default: '').presence
			unless sub_label.blank?
				content += @template.render partial: 'awesome/forms/sub_label', locals: {sub_label: sub_label.to_s.html_safe}
				content = content
			end

			if option_plain == true
				return content.html_safe
			else
				super do
					content = option_before.to_s.html_safe + content.to_s.html_safe + option_after.to_s.html_safe
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
			@template.render partial: 'awesome/forms/input_list_open', locals: {label: label.to_s.html_safe, errors: errors.to_s.html_safe}
		end

		# TODO: Use i18n for help of input list
		def input_list_close(field = nil, help = nil)
			unless field.blank?
				errors = get_errors @object, field
			else
				errors = nil
			end
			@template.render partial: 'awesome/forms/input_list_close', locals: {errors: errors.to_s.html_safe, help: help.to_s.html_safe}
		end

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

		def get_errors(object, field, hide_errors = nil)
			object && hide_errors.blank? && object.errors[field] ? object.errors[field].join(@template.tag(:br)).html_safe : ''
		end

		def cancel_button(redirect)
			@template.render partial: 'awesome/forms/cancel_button', locals: { redirect: redirect }
		end

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

ActionView::Base.default_form_builder = AwesomeForms::AwesomeFormBuilder # Make AwesomeForms the default form builder
