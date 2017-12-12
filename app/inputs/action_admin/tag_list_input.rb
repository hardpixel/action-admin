module ActionAdmin
  class TagListInput < SelectListInput
    def input(wrapper_options)
      input_html_options[:data] ||= {}
      input_html_options[:data].merge!({ tags: true })

      super
    end
  end
end
