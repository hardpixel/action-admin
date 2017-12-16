module ActionAdmin
  class SeoAnalysisInput < SimpleForm::Inputs::Base
    def input(wrapper_options)
      seo_data_options = {
        seo_analysis: '',
        content:      content_html_id,
        slug:         id_from_html(slug_hidden_field),
        title:        id_from_html(title_hidden_field),
        description:  id_from_html(description_hidden_field),
        keywords:     id_from_html(keywords_hidden_field),
        score:        id_from_html(score_hidden_field)
      }

      template.content_tag :div, class: 'seo-analysis', data: seo_data_options  do
        template.concat title_hidden_field
        template.concat description_hidden_field
        template.concat keywords_hidden_field
        template.concat score_hidden_field
        template.concat slug_hidden_field if options[:slug_input].present?

        template.concat seo_keyword_input
        template.concat seo_preview
        template.concat seo_output
      end
    end

    def seo_keyword_input
      content = @builder.text_field(:seo_keywords, placeholder: 'Enter focus keyword...', data: { seo_keyword: '' })
      content_tag :div, content, class: 'seo-keyword'
    end

    def seo_preview
      icons = { icon_desktop: 'mdi mdi-desktop-mac', icon_mobile: 'mdi mdi-cellphone', icon_edit: 'mdi mdi-pencil' }
      content_tag :div, nil, class: 'seo-preview', data: { seo_preview: '' }.merge(icons)
    end

    def seo_output
      content_tag :div, nil, class: 'seo-output', data: { seo_output: '' }
    end

    def title_hidden_field
      attrib = options.fetch :title, :seo_title
      @builder.hidden_field(attrib)
    end

    def description_hidden_field
      attrib = options.fetch :description, :seo_description
      @builder.hidden_field(attrib)
    end

    def keywords_hidden_field
      attrib = options.fetch :keywords, :seo_keywords
      @builder.hidden_field(attrib)
    end

    def slug_hidden_field
      attrib = options.fetch :slug, :slug
      @builder.hidden_field(attrib)
    end

    def score_hidden_field
      attrib = options.fetch :score, :seo_keywords
      @builder.hidden_field(attrib)
    end

    def label(wrapper_options)
      ''
    end

    private

      def content_html_id
        attrib = options.fetch :content, detect_content_attribute
        id_from_html @builder.hidden_field(attrib)
      end

      def detect_content_attribute
        items  = ['content', 'description', 'body']
        attrib = object.class.attribute_names.select { |n| n.in? items }

        attrib.sort_by { |a| items.index(a).to_i }.first
      end

      def id_from_html(field)
        field.to_s[/id=\"(.*)\"/, 1]
      end
  end
end
