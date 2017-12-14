module ActionAdmin
  class UploadInput < SimpleForm::Inputs::FileInput
    def input(wrapper_options = nil)
      version = input_html_options.delete(:small)
      out = ActiveSupport::SafeBuffer.new
      if object.send("#{attribute_name}?")
        out << template.image_tag(object.send(attribute_name).tap {|o| break o.send(version) if version}.send('url'))
      end
      out << @builder.hidden_field("#{attribute_name}_cache").html_safe
      out << @builder.file_field(attribute_name, input_html_options)
    end
  end
end
