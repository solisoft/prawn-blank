# frozen_string_literal: true

module Prawn::Blank
  class Appearance
    class Item
      def self.arguments(args = {})
        @arguments = args
      end

      def cache_key(elem); end
    end

    attr_reader :document

    STYLE = {
      border_color: '202020',
      background_color: 'ffffff',
      border_width: 1
    }.freeze

    def initialize(document)
      @document = document
      @cache = {}
      # @style = STYLE.dup
    end

    def render(dict)
      dict = {
        Subtype: :Form,
        Resources: { ProcSet: %i[PDF ImageC ImageI ImageB] }
      }.merge(dict)

      result = @document.ref!(dict)
      @document.state.page.stamp_stream(result) do
        yield
      end
      @document.acroform.add_resources(result.data[:Resources])
      result
    end

    def button(element)
      element.width = 10 if !element.width || (element.width <= 0)
      element.height = 10 if !element.height || (element.height <= 0)
      width = element.width
      height = element.height
      style = element.style ||= Prawn::ColorStyle(@document, 'ffffff', '000000')
      border_style = element.border_style ||= Prawn::BorderStyle(@document, 0)
      cached(:checkbox_off, width, height, style, border_style) do
        render(BBox: [0, 0, width, height]) do
          document.canvas do
            # render background
            document.fill_color(*denormalize_color(style[:BG]))
            document.stroke_color(*denormalize_color(style[:BC]))
            document.line_width(border_style[:W])
            bw = border_style[:W] / 2.0
            document.fill_and_stroke_rectangle([bw, height - bw], width - border_style[:W], height - border_style[:W])
          end
        end
      end
    end

    alias button_over button
    alias button_down button

    def checkbox_off(element)
      element.width = 10 if !element.width || (element.width <= 0)
      element.height = 10 if !element.height || (element.height <= 0)
      width = element.width
      height = element.height
      style = element.style ||= Prawn::ColorStyle(@document, 'ffffff', '000000')
      border_style = element.border_style ||= Prawn::BorderStyle(@document, 0)
      cached(:checkbox_off, width, height, style, border_style) do
        render(BBox: [0, 0, width, height]) do
          document.canvas do
            # render background
            document.fill_color(*denormalize_color(style[:BG]))
            document.stroke_color(*denormalize_color(style[:BC]))
            document.line_width(border_style[:W])
            bw = border_style[:W] / 2.0
            document.fill_and_stroke_rectangle([bw, height - bw], width - border_style[:W], height - border_style[:W])
          end
        end
      end
    end

    alias checkbox_off_over checkbox_off
    alias checkbox_off_down checkbox_off

    def checkbox_on(element)
      element.width = 10 if !element.width || (element.width <= 0)
      element.height = 10 if !element.height || (element.height <= 0)
      width = element.width
      height = element.height
      style = element.style ||= Prawn::ColorStyle(@document, 'ffffff', '000000')
      border_style = element.border_style ||= Prawn::BorderStyle(@document, 0)
      cached(:checkbox_on, width, height, style, border_style) do
        render(BBox: [0, 0, width, height]) do
          document.canvas do
            # render background
            document.fill_color(*denormalize_color(style[:BG]))
            document.stroke_color(*denormalize_color(style[:BC]))
            document.line_width(border_style[:W])
            bw = border_style[:W] / 2.0
            document.fill_and_stroke_rectangle([bw, height - bw], width - border_style[:W], height - border_style[:W])
            document.stroke_line(0, 0, width, height)
            document.stroke_line(width, 0, 0, height)
          end
        end
      end
    end

    alias checkbox_on_over checkbox_on
    alias checkbox_on_down checkbox_on

    def radio_off(element)
      element.width = 10 if !element.width || (element.width <= 0)
      element.height = 10 if !element.height || (element.height <= 0)
      width = element.width
      height = element.height
      style = element.style ||= Prawn::ColorStyle(@document, 'ffffff', '000000')
      border_style = element.border_style ||= Prawn::BorderStyle(@document, 0)
      cached(:radio_off, width, height, style, border_style) do
        render(BBox: [0, 0, width, height]) do
          document.canvas do
            # render background
            document.fill_color(*denormalize_color(style[:BG]))
            document.stroke_color(*denormalize_color(style[:BC]))
            document.line_width(border_style[:W])
            rx = (width / 2.0)
            ry = (height / 2.0)
            document.fill_and_stroke_ellipse([rx, ry], rx - border_style[:W], ry - border_style[:W])
          end
        end
      end
    end

    alias radio_off_over radio_off
    alias radio_off_down radio_off

    def radio_on(element)
      element.width = 10 if !element.width || (element.width <= 0)
      element.height = 10 if !element.height || (element.height <= 0)
      width = element.width
      height = element.height
      style = element.style ||= Prawn::ColorStyle(@document, 'ffffff', '000000')
      border_style = element.border_style ||= Prawn::BorderStyle(@document, 0)
      cached(:radio_on, width, height, style, border_style) do
        render(BBox: [0, 0, width, height]) do
          document.canvas do
            # render background
            document.fill_color(*denormalize_color(style[:BG]))
            document.stroke_color(*denormalize_color(style[:BC]))
            document.line_width(border_style[:W])
            rx = (width / 2.0)
            ry = (height / 2.0)
            document.fill_and_stroke_ellipse([rx, ry], rx - border_style[:W], ry - border_style[:W])

            document.fill_color(*denormalize_color(style[:BC]))
            document.fill_ellipse([rx, ry], rx - border_style[:W] - 2, ry - border_style[:W] - 2)
          end
        end
      end
    end

    alias radio_on_over radio_on
    alias radio_on_down radio_on

    def text_field(element, bgcolor = 'ffffff')
      text_style = element.text_style ||= Prawn::TextStyle(
        @document, 'Helvetica', :normal, 9, '000000'
      )
      border_style = element.border_style ||= Prawn::BorderStyle(@document, 0)

      element.width = 100 if !element.width || (element.width <= 0)
      element.height = text_style.size + 6 + 2 * border_style[:W] if !element.height || (element.height <= 0)
      width = element.width
      height = element.height
      style = Prawn::ColorStyle(@document, bgcolor, '000000')
      multiline = element.multiline
      value = element.value
      # cached(:text_field, width, height, style, border_style, text_style, multiline, value) do
      render(BBox: [0, 0, width, height]) do
        document.canvas do
          document.save_font do
            # render background
            document.fill_color(*denormalize_color(style[:BG]))
            document.stroke_color(*denormalize_color(style[:BC]))
            document.line_width(border_style[:W])
            if border_style[:W] > 0
              bw = border_style[:W] / 2.0
              document.fill_and_stroke_rectangle(
                [bw, height - bw], width - border_style[:W], height - border_style[:W]
              )
            else
              document.fill_rectangle(
                [0, height], width, height
              )
            end
            document.font(text_style.font, size: text_style.size, style: text_style.style)
            document.fill_color(*text_style.color)

            if value
              document.draw_text(
                value,
                at: [
                  0,
                  [1, height - document.font_size - 1.5].max
                ]
              )
            end
          end
        end
      end
      # end
    end

    protected

    def cached(*args)
      @cache[args] ||= yield
    end

    def denormalize_color(color)
      s = color.size
      if s == 1 # gray
        return [0, 0, 0, color[0]]
      elsif s == 3 # rgb
        return Prawn::Graphics::Color.rgb2hex(color.map { |component| component * 255.0 })
      elsif s == 4 # cmyk
        return color.map { |component| component * 100.0 }
      end

      raise "Unknown color: #{color}"
    end
  end
end
