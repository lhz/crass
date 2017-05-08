require "./token"

module Crass
  class Parser

    def self.run(source_file)
      parser = Parser.new
      parser.run source_file
    end

    # Run the parser
    def run(source_file)
      source_code = File.read(source_file)

      t0 = Time.now
      source = tokenize(source_code)
      tt = Time.now - t0
      puts "Tokenized source in #{tt.total_milliseconds} ms."

      dump_source source
    end

    # Tokenize source code text
    def tokenize(source_code)
      # Source elements
      source    = Source.new
      statement = Statement.new
      token     = Token.new

      # Position in source text
      line      = 1
      column    = 0

      # States
      inside_single_quotes = false
      inside_double_quotes = false
      inside_comment       = false
      backslash_escape     = false

      source_code.each_char do |char|
        column += 1
        next if inside_comment && char != '\n'
        if backslash_escape
          if char == '\n'
            line, column = line + 1, 0
          else
            token.add '\\', line, column
            token.add char, line, column
          end
          backslash_escape = false
          next
        end
        case char
        when '\\' # Backslash
          backslash_escape = true
          next
        when '\n' # Newline
          unless token.empty?
            statement << token
            token = Token.new
          end
          unless statement.empty?
            source << statement
            statement = Statement.new
          end
          inside_comment = false
          line, column = line + 1, 0
        when ' ', '\t' # Space or tab
          if inside_single_quotes || inside_double_quotes
            token.add char, line, column
          else
            unless token.empty?
              statement << token
              token = Token.new
            end
          end
          if char == '\t'
            column -= 1
            column += 8 - (column % 8)
          end
        when '\'' # Single quote
          token.add char, line, column
          inside_single_quotes = !inside_single_quotes unless inside_double_quotes
        when '"' # Double quote
          token.add char, line, column
          inside_double_quotes = !inside_double_quotes unless inside_single_quotes
        when ':' # Statement delimiter
          if token.empty? && !statement.empty?
            source << statement
            statement = Statement.new
          else
            token.add char, line, column
          end
        when ';' # Comment delimiter
          if inside_single_quotes || inside_double_quotes
            token.add char, line, column
          else
            inside_comment = true
          end
        else # Other character
          token.add char, line, column
        end
      end

      return source
    end

    def dump_source(source)
      lwmax = source.max_of { |s| s[0].line }.to_s.size
      source.each do |statement|
        puts "%#{lwmax}d: %s" % [
               statement[0].line,
               statement.map(&.to_s).join " | "
             ]
      end
    end
  end
end
