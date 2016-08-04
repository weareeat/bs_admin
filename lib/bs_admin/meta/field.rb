module BsAdmin
  class Meta
    class Field
      attr_accessor :name, :type, :options
      attr_accessor :title, :hidden

      def initialize hash
        @name = hash[:name]
        @type = hash[:type]
        @options = {}

        @title = hash[:name].to_s.humanize
        @hidden = false
        @hidden = hash[:hidden] if hash[:hidden]

        if hash[:options]
          @options = hash[:options]
          @title = hash[:options][:title] if hash[:options][:title]
          @content_type = hash[:options][:content_type] if hash[:options][:content_type]
        end
      end

      def content_type
        @content_type ||= guess_content_type
      end

      def self.guess_type_initialize  raw_name, raw_type, options
        final_name, final_type = raw_name, raw_type
        if raw_type == :integer
          if raw_name.ends_with? '_cents'
            final_name.slice!('_cents')
            final_type = :money 
          end
        end

        if raw_type == :string
          final_type = :image if ['_image', '_pic', '_picture', '_photo'].any?{ |i| raw_name.ends_with?(i) }
        end

        self.new({ name: final_name, type: final_type, options: options })
      end

      def guess_content_type
        if @type == :string
          :title if @name.include?('title')
          :name if @name.include?('name')
          :video_link if @name.include?('video') and @name.include?('link')
          :summary if @name.include?('summary') or @name.include?('description')
          :text if @name.include?('content') or @name.include?('message')
        else
          @type
        end
      end

      STRING_BASED_FIELD_TYPES = %w(string email password permalink link image select file color_picker)
      TEXT_BASED_FIELD_TYPES = %w(text wysi)
      OTHER_FIELD_TYPES = %w(checkbox custom currency date radiogroup time datetime number money integer tags view)
      ALL_FIELD_TYPES = STRING_BASED_FIELD_TYPES.concat TEXT_BASED_FIELD_TYPES.concat OTHER_FIELD_TYPES
    end
  end
end
