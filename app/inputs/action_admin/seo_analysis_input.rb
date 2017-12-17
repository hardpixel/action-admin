module ActionAdmin
  class SeoAnalysisInput < SimpleForm::Inputs::Base
    def input(wrapper_options)
      seo_data_options = {
        seo_analysis: '',
        base_url:     base_url,
        text:         text_html_id,
        slug:         id_from_html(slug_hidden_field),
        title:        id_from_html(title_hidden_field),
        meta:         id_from_html(description_hidden_field),
        keywords:     id_from_html(keywords_hidden_field),
        score:        id_from_html(score_hidden_field)
      }

      template.content_tag :div, class: 'seo-analysis', data: seo_data_options  do
        template.concat title_hidden_field
        template.concat description_hidden_field
        template.concat keywords_hidden_field
        template.concat score_hidden_field
        template.concat slug_hidden_field if options[:slug_input].present?

        template.concat seo_keyword
        template.concat seo_preview
        template.concat seo_output
      end
    end

    def base_url
      url_value = object.try(options.fetch :slug, :slug)
      method    = options.fetch :url, ActionAdmin.config.app_urls

      if object.new_record?
        template.root_url.chomp('/')
      else
        template.try(method, object).to_s.sub(url_value, '').chomp('/')
      end
    end

    def seo_keyword
      content = @builder.text_field(:seo_keywords, placeholder: 'Enter focus keyword...', data: { seo_keyword: '' })
      content_tag :div, content, class: 'seo-keyword'
    end

    def seo_preview
      content_tag :div, nil, class: 'seo-preview', data: { seo_preview: '' }
    end

    def seo_output
      content_tag :div, nil, class: 'seo-output', data: { seo_output: '' }
    end

    def title_hidden_field
      attrib = options.fetch :title, :seo_title
      @builder.hidden_field(attrib, data: { default: attribute_default(attrib) })
    end

    def description_hidden_field
      attrib = options.fetch :description, :seo_description
      @builder.hidden_field(attrib, data: { default: attribute_default(attrib) })
    end

    def keywords_hidden_field
      attrib = options.fetch :keywords, :seo_keywords
      @builder.hidden_field(attrib, data: { default: attribute_default(attrib) })
    end

    def slug_hidden_field
      attrib = options.fetch :slug, :slug
      @builder.hidden_field(attrib, data: { default: attribute_default(attrib) })
    end

    def score_hidden_field
      attrib = options.fetch :score, :seo_keywords
      @builder.hidden_field(attrib, data: { default: attribute_default(attrib) })
    end

    def label(wrapper_options)
      ''
    end

    private

      def attribute_default(attrib)
        items = object.try(attribute_name).select do |k, v|
          "#{k}" == "#{attrib}" || "#{k}" == "#{attrib}".sub('seo_', '')
        end

        items.values.first
      end

      def text_html_id
        attrib = options.fetch :content, detect_text_attribute
        id_from_html @builder.hidden_field(attrib)
      end

      def detect_text_attribute
        items  = ['content', 'description', 'body']
        attrib = object.class.attribute_names.select { |n| n.in? items }

        attrib.sort_by { |a| items.index(a).to_i }.first
      end

      def id_from_html(field)
        field.to_s[/id=\"(.*)\"/, 1]
      end
  end
end
