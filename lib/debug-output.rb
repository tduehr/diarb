# 
#  irb.rb
#  diarb
#  
#  Created by tduehr on 2010-05-12.
#  Copyright 2010 tduehr.
#  See LICENSE file for details.
#
require 'pp'

module IRB
  class ReadlineInputMethod < InputMethod
    def gets
      # STDOUT.puts @prompt.inspect
      # STDOUT.puts self
      pp [:gets]
      if l = readline(@prompt, false)
        pp [:realine, @prompt, l]
        HISTORY.push(l) if !l.empty?
        @line[@line_no += 1] = l + "\n"
      else
        @eof = true
        l
      end
    end
  end

  class Irb
    def eval_input
      pp :eval_input
      @scanner.set_prompt do |ltype, indent, continue, line_no|
        pp [:setprompt, ltype, indent, continue, line_no]
        if ltype
          f = @context.prompt_s
        elsif continue
          f = @context.prompt_c
        elsif indent > 0
          f = @context.prompt_n
        else @context.prompt_i
          f = @context.prompt_i
        end
        f = "" unless f
        if @context.prompting?
          @context.io.prompt = p = prompt(f, ltype, indent, line_no)
        else
          @context.io.prompt = p = ""
        end
        if @context.auto_indent_mode
          unless ltype
            ind = prompt(@context.prompt_i, ltype, indent, line_no)[/.*\z/].size + indent * 2 - p.size
            ind += 2 if continue
            @context.io.prompt = p + " " * ind if ind > 0
          end
        end
      end

      @scanner.set_input(@context.io) do
        signal_status(:IN_INPUT) do
          if l = @context.io.gets
            pp [:IN_INPUT, l, @context.io]
            print l if @context.verbose?
          else
            pp [:else, l]
            if @context.ignore_eof? and @context.io.readable_atfer_eof?
              l = "\n"
              if @context.verbose?
                printf "Use \"exit\" to leave %s\n", @context.ap_name
              end
            end
          end
          l
        end
      end

      @scanner.each_top_level_statement do |line, line_no|
        signal_status(:IN_EVAL) do
          begin
            line.untaint
            @context.evaluate(line, line_no)
            output_value if @context.echo?
            exc = nil
          rescue Interrupt => exc
          rescue SystemExit, SignalException
            raise
          rescue Exception => exc
          end
          if exc
            print exc.class, ": ", exc, "\n"
            if exc.backtrace[0] =~ /irb(2)?(\/.*|-.*|\.rb)?:/ && exc.class.to_s !~ /^IRB/
              irb_bug = true 
            else
              irb_bug = false
            end

            messages = []
            lasts = []
            levels = 0
            for m in exc.backtrace
              m = @context.workspace.filter_backtrace(m) unless irb_bug
              if m
                if messages.size < @context.back_trace_limit
                  messages.push "\tfrom "+m
                else
                  lasts.push "\tfrom "+m
                  if lasts.size > @context.back_trace_limit
                    lasts.shift 
                    levels += 1
                  end
                end
              end
            end
            print messages.join("\n"), "\n"
            unless lasts.empty?
              printf "... %d levels...\n", levels if levels > 0
              print lasts.join("\n")
            end
            print "Maybe IRB bug!!\n" if irb_bug
          end
          if $SAFE > 2
            abort "Error: irb does not work for $SAFE level higher than 2"
          end
        end
      end
    end
  end
end

class RubyLex
  def gets
    pp [:rubylex]
    l = ""
    while c = getc
      l.concat(c)
      break if c == "\n"
    end
    return nil if l == "" and c.nil?
    l
  end  
end