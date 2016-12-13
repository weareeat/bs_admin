module BsAdmin
  class Meta
    class Field
      attr_accessor :name, :type, :options
      attr_accessor :title, :hidden, :multiple_upload
      def initialize hash
        @name = hash[:name]
        @type = hash[:type]
        @options = {}

        @title = hash[:name].to_s.humanize
        @hidden = false
        @hidden = hash[:hidden] if hash[:hidden]
        @multiple_upload = false

        if hash[:options]
          @options = hash[:options]
          @title = hash[:options][:title] if hash[:options][:title]
          @multiple_upload = hash[:options][:multiple_upload] if hash[:options][:multiple_upload]
        end
      end
    end
  end
end
