module PaperclipConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def after_commit(*args, &block)
      options = args.pop if args.last.is_a? Hash
      if options
        case options[:on]
          when :create
            after_create(*args, &block)
          when :update
            after_update(*args, &block)
          when :destroy
            after_destroy(*args, &block)
          else
            after_save(*args, &block)
        end
      else
        after_save(*args, &block)
      end
    end
  end
end

