# 
#  cmdext.rb
#  diarb
#  
#  Created by tduehr on 2010-05-12.
#  Copyright 2010 tduehr.
#  See LICENSE file for details.
#

def self.diary_start(filename, mode="a")
  if self.diary?
    raise "diary already started"
  else
    self.context.start_diary(filename, mode)
  end
end

def self.diary_stop
  self.context.stop_diary
end

def self.diary?
  self.context.diary?
end
