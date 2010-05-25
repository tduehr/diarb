# 
#  cmdext.rb
#  diarb
#  
#  Created by tduehr on 2010-05-12.
#  Copyright 2010 tduehr.
#  See LICENSE file for details.
#

module Diarb
  module CommandExtentions
    def diary_start(filename, mode="a")
      if diary?
        self.context.io.add_diary(filename, mode)
      else
        diar = IOMethod.new(filename, mode, self.context.io, self.context.instance_variable_get(:@output_method))
        self.context.instance_variable_set(:@io, diar)
        self.context.instance_variable_set(:@output_method, diar)
      end
      @diary = true
    end

    def diary_stop(filename = :all)
      rem = self.context.io.close(filename)
      @diary = !!rem
      pp [:diary_stop, @diary]
      if !@diary
        diar = self.context.io
        self.context.instance_variable_set(:@io, diar.input)
        self.context.instance_variable_set(:@output_method, diar.output)
      end
      rem
    end

    def diary?
      @diary ||= false
    end
  end
end