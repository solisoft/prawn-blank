# frozen_string_literal: true

module Prawn::Blank
  class Radio < Field
    attr_accessor :check_string, :check_style, :value

    def finalize(document)
      # render this field

      app = appearance || document.default_appearance

      @data[:AP] =
        if check_string
          { N: { Off: app.checkbox_off(self), Yes: app.checkbox_on(self) },
            R: { Off: app.checkbox_off_over(self), Yes: app.checkbox_on_over(self) },
            D: { Off: app.checkbox_off_down(self), Yes: app.checkbox_on_down(self) } }
        else
          { N: { :Off => app.radio_off(self), @value => app.radio_on(self) },
            R: { :Off => app.radio_off_over(self), @value => app.radio_on_over(self) },
            D: { :Off => app.radio_off_down(self), @value => app.radio_on_down(self) } }
        end
      @data[:AS] = parent.value == @value ? @value : :Off
      @data[:V] = @value
      nil
    end

    protected

    def default_options
      super.merge(FT: :Btn, Ff: 32_768)
    end
  end
end
