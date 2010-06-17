# 
#  context.rb
#  diarb
#  
#  Created by tduehr on 2010-05-25.
#  Copyright 2010 tduehr.
#  See LICENSE file for details.
#
# module Diarb
#   module ContextExtensions
module IRB
  class Context
    attr_accessor :diary
    def evaluate(line, line_no, test="")
      @line_no = line_no
      @diary.print_input(line) if diary?
      lv = @workspace.evaluate(self, line, irb_path, line_no)
      @diary.print_output(lv) if diary?
      set_last_value(lv)
      # set_last_value(@workspace.evaluate(self, line, irb_path, line_no))
    end
    
    def start_diary(filename, mode)
      if @diary
        raise "diary already started #{@diary.filename}"
      else
        begin
          @diary = Diarb::Diary.new(filename, mode)
        rescue => e
          @diary = nil
          raise e
        end
      end
    end
    
    def stop_diary
      if @diary
        @diary.close
        @diary = nil
      end
    end
    
    def diary?
      !!@diary
    end
  end
end
