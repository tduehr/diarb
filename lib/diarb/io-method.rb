# 
#  io-method.rb
#  diarb
#  
#  Created by tduehr on 2010-05-12.
#  Copyright 2010 tduehr.
#  See LICENSE file for details.
#

module Diarb
  class IOMethod
    attr_reader :diaries
    attr_reader :input
    attr_reader :output
    
    def initialize(filename, mode, input, output)
      file = File.open(filename, mode)
      file.sync = true
      @input = input
      @output = output
      @diaries = {filename => file}
    end

    # add a diary file to the list
    def add_diary(filename, mode = "a")
      file = File.open(filename, mode)
      @diaries[filename] = file
    end

    def close(filename = :all)
      if filename == :all
        @diaries.each do |fn, file|
          file.close
        end
        @diaries = nil
      else
        file = @diaries.delete(filename)
        file.close if file
      end
      @diaries
    end

    # proxy InputMethod#gets so we can write to diary files
    def gets
      ln = @input.gets
      pp [:mygets, @input, ln]
      @diaries.each do |fn, file|
        file.print ln
      end
      ln
    end

    # proxy OutputMethod#print so we can write to diary files
    def print(*opts)
      STDOUT.print("#{opts}")
      @diaries.each do |fn, file|
        file.print "\# "
        file.print *opts
      end
    end

    # delegate respond_to? to the instance variables if not handled locally
    def respond_to?(include_priv = false)
      (super(include_priv) || @input.respond_to?(include_priv) || @output.respond_to?(include_priv))
    end

    # all other methods get delegated to the input and output instance variables
    def method_missing(meth, *args)
      pp [meth, *args]
      case
      when @input.respond_to?(meth)
        @input.send(meth, *args)
      when @output.respond_to?(meth)
        @output.send(meth, *args)
      else
        raise NoMethodError.new("undefined method '#{meth.to_s}' for #{self.inspect}")
      end
    end
  end
end