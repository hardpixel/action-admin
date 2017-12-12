module ActionAdmin
  class SelectListInput < SimpleForm::Inputs::CollectionSelectInput
    def input(wrapper_options)
      input_html_options[:data] ||= {}
      input_html_options[:data].merge!({
        select_box:  '',
        list:        true,
        placeholder: input_html_options[:placeholder]
      })

      super
    end
  end
end
