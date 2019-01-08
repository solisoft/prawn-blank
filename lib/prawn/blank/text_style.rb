# frozen_string_literal: true

module Prawn::Blank
  class TextStyle < PDF::Core::LiteralString
    attr_reader :font, :color, :size

    def initialize(document, font, size, color, font_subset = 0)
      @font = font
      @font_subset = font_subset
      @size = size
      @color = color
      @color = [@color] unless color.is_a? Array
      super(
        "/#{document.font(font).identifier_for(font_subset)} #{size} " \
        "Tf #{document.send(:color_to_s, *@color)} #{color_cmd(@color)}"
      )
    end

    def color_cmd(color)
      if color[0].is_a? String
        'rg'
      else
        'k'
      end
    end
  end
end
