#
#  diary.rb
#  diarb
#
#  Created by tduehr on 2010-06-09.
#  Copyright 2010 tduehr.
#  See LICENSE file for details.
#

module Diarb
  class Diary
    attr_reader :file
    attr_reader :filename
    attr_reader :mode
    def initialize(filename, mode="a")
      @file = File.open(filename, mode)
      @mode = mode
      @filename = filename
    end

    def print_input(line)
      @file.print line
      @file.flush
    end

    def print_output(val)
      @file.print "\# =>", val.inspect, "\n"
      @file.flush
    end

    def close
      @file.close
    end
  end
end
