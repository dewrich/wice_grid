# encoding: UTF-8
module Wice

  class GridOutputBuffer < String #:nodoc:

    attr_reader :stubborn_output_mode
    attr_accessor :return_empty_strings_for_nonexistent_filters

    def stubborn_output_mode=(m)
      @stubborn_output_mode = m
    end

    def initialize(*attrs)
      super(*attrs)
      @filters = HashWithIndifferentAccess.new
      @first_output = false
      @stubborn_output_mode = false
    end

    def to_s
      if @first_output || ! @stubborn_output_mode
        super.html_safe_if_necessary
      else
        @first_output = true
        ''
      end
    end

    def add_filter(detach_with_id, filter_code)
      raise  WiceGridException.new("Detached ID #{detach_with_id} is already used!") if @filters.has_key? detach_with_id
      @filters[detach_with_id] = filter_code
    end

    def filter_for detach_with_id
      unless @filters.has_key? detach_with_id
        if @return_empty_strings_for_nonexistent_filters
          return ''
        else
          raise  WiceGridException.new("No filter with Detached ID '#{detach_with_id}'!")
        end
      end
      if @filters[detach_with_id] == false
        raise  WiceGridException.new("Filter with Detached ID '#{detach_with_id}' has already been requested once! There cannot be two instances of the same filter on one page")
      end
      res = @filters[detach_with_id]
      @filters[detach_with_id] = false
      return res
    end

    alias_method :[], :filter_for

  end
end