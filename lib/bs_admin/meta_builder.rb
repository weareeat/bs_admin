module BsAdmin
  class MetaBuilder
    def initialize selfie
      @hash = { :class => selfie }
      @hash[:filters] = []
      @hash[:fields] = []
      @hash[:relationships] = []
      @hash[:custom_pages] = []
      @hash[:links] = []
      @hash[:paginate_page_size] = nil

      @hash[:guess_fields] = false
      @hash[:guess_fields_default_args] = {}
    end

    def build
      Meta.new(@hash)
    end

    [:title_field, :index_fields, :populate_batch_count, :sort, :base_path, :can].each do |type|
      define_method type do |value|
        @hash[type] = value
      end
    end

    %w(has_many has_one belongs_to).each do |type|
      define_method type do |field, args={}|
        @hash[:relationships] << { field: field, type: type.to_sym, options: args }
      end
    end

    def filter type, field, args={}
      @hash[:filters] << { type: type, field: field, options: args }
    end

    def custom_page template, args={}
      @hash[:custom_pages] << { template: template, options: args }
    end

    def link name, href, args={}
      @hash[:links] << { name: name, href: href, options: args }
    end

    def paginate paginate_page_size
      @hash[:paginate_page_size] = paginate_page_size
    end

    def fields
      meta_field_builder = MetaFieldBuilder.new()
      yield(meta_field_builder)
      @hash[:fields] = meta_field_builder.fields
    end

    def guess_fields default_args={}
      @hash[:guess_fields] = true
      @hash[:guess_fields_default_args] = default_args
    end

    class MetaFieldBuilder
      attr_accessor :fields, :guess_fields

      def initialize
        @fields = []
        @guess_fields = false
      end

      BsAdmin::Meta::Field::ALL_FIELD_TYPES.each do |type|
        define_method type do |name, args={}|
          @fields << { type: type.to_sym, name: name, options: args }
        end
      end

      def placeholder name, description
        @fields << { type: :placeholder, name: name, options: { description: description } }
      end
    end
  end
end
