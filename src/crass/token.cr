module Crass

  alias Source    = Array(Statement)
  alias Statement = Array(Token)

  class Token
    property line   : Int32
    property column : Int32

    def initialize
      @line   = -1
      @column = -1
      @string = String::Builder.new
    end

    def add(char, line, column)
      if empty?
        @line   = line
        @column = column
      end
      @string << char
    end

    def empty?
      @string.empty?
    end

    def string
      @string.to_s
    end

    def to_s(debug = false)
      if debug
        "'#{string}' [#{column - 1}]"
      else
        "'#{string}'"
      end
    end
  end
end
