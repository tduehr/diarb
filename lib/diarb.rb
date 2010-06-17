# 
#  diarb.rb
#  diarb
#  
#  Created by tduehr on 2010-05-12.
#  Copyright 2010 tduehr.
#  See LICENSE file for details.
#

require 'irb'
# require './debug-output'

module Diarb
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR

  require ::File.join(LIBPATH, 'diarb', 'diary')
  require ::File.join(LIBPATH, 'diarb', 'context')
  # require ::File.join(LIBPATH, 'diarb', 'io-method')
  require ::File.join(LIBPATH, 'diarb', 'cmdext')
end

# self.extend(Diarb::CommandExtensions)
