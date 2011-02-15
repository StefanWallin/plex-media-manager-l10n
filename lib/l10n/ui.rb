module L10n
  module UI
    COLORS = {:reset  => "\e[0m",
              :black  => "\e[30m",
              :red    => "\e[31m",
              :green  => "\e[32m",
              :yellow => "\e[33m",
              :blue   => "\e[34m",
              :purple => "\e[35m",
              :cyan   => "\e[36m",
              :white  => "\e[37m"}.freeze

    def self.status(*message)
      message.each do |m|
        puts "~ #{m}"
      end
    end

    def self.puts(*message)
      $stdout.puts(*message)
    end

    def self.print(*message)
      $stdout.print(*message)
    end

    def self.abort(message)
      Kernel.abort(red("! #{message}"))
    end

    def self.color(color, *message)
      raise ArgumentError, "no such color: #{color}. must be one of #{color.keys.join(', ')}" unless COLORS.include?(color.to_sym)

      if not (@tty || STDOUT.tty?)
        message.join
      elsif message.any?
        "#{COLORS[color]}#{message.join}#{COLORS[:reset]}"
      else
        COLORS[color]
      end
    end

    def self.method_missing(name, *args, &block)
      if COLORS.include?(name)
        color(name, *args)
      else
        super
      end
    end

    # http://nex-3.com/posts/73-git-style-automatic-paging-in-ruby
    def self.run_pager
      return if PLATFORM =~ /win32/
      return unless STDOUT.tty?

      read, write = IO.pipe

      unless Kernel.fork # Child process
        STDOUT.reopen(write)
        STDERR.reopen(write) if STDERR.tty?
        read.close
        write.close
        @tty = true if STDOUT.tty?
        return
      end

      # Parent process, become pager
      STDIN.reopen(read)
      read.close
      write.close

      ENV['LESS'] = 'FSRX' # Don't page if the input is short enough

      Kernel.select [STDIN] # Wait until we have input before we start the pager
      pager = ENV['PAGER'] || 'less'
      exec pager rescue exec "/bin/sh", "-c", pager
    end
  end
end
