require "./crass/*"

module Crass
  module CLI
    extend self

    class Usage < Exception; end

    def run
      source_file = ARGV.shift? || raise Usage.new
      Crass::Parser.run source_file
    rescue ex : Usage
      abort "Usage: #{PROGRAM_NAME} <source file>"
    rescue ex
      abort "#{PROGRAM_NAME}: #{ex.message}"
    end
  end
end

Crass::CLI.run
