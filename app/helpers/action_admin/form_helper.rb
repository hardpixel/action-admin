module ActionAdmin
  module FormHelper
    # Admin simple form
    def admin_form_for(object, *args, &block)
      options = args.extract_options!
      builder = { builder: ActionAdmin::Form::Builder }
      options = options.merge(builder) unless options[:builder]

      simple_form_for(object, *(args << options), &block)
    end

    # Admin simple form fields
    def admin_fields_for(*args, &block)
      options = args.extract_options!
      builder = { builder: ActionAdmin::Form::Builder }
      options = options.merge(builder) unless options[:builder]

      simple_form_for(*(args << options), &block)
    end

    # Admin simple form with placeholders
    def admin_minimal_form_for(object, *args, &block)
      options = args.extract_options!
      options = options.merge(builder: ActionAdmin::Form::MinimalBuilder)

      admin_form_for(object, *(args << options), &block)
    end

    # Admin simple form fields with placeholders
    def admin_minimal_fields_for(*args, &block)
      options = args.extract_options!
      options = options.merge(builder: ActionAdmin::Form::MinimalBuilder)

      admin_fields_for(*(args << options), &block)
    end
  end
end
