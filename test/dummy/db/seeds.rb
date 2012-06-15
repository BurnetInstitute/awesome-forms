# Allow mass assignment even if attr_accessible is not set in models. Returns all attributes and not just sanitized_attributes from sanitize.
module ActiveModel
  module MassAssignmentSecurity
    class Sanitizer
      def sanitize(attributes, authorizer)
        attributes
      end
    end
  end
end


['IT', 'Facilities', 'PAC', 'CPH', 'Admin', 'Finance'].each do |department|
  Department.create name: department
end
