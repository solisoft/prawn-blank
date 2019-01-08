# frozen_string_literal: true

module Prawn::Blank
  class Radio < Field
    attr_writer :value

    attr_reader :value

    def finalize(document)
      # render this field

      app = appearance || document.default_appearance

      @data[:AP] = { N: { :Off => app.radio_off(self), @value => app.radio_on(self) },
                     R: { :Off => app.radio_off_over(self), @value => app.radio_on_over(self) },
                     D: { :Off => app.radio_off_down(self), @value => app.radio_on_down(self) } }
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
