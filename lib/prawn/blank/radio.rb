# frozen_string_literal: true

module Prawn::Blank
  class Radio < Field
    attr_accessor :check_string, :check_style, :value

    def finalize(document)
      # render this field

      app = appearance || document.default_appearance

      radio_index = (parent.children.length - 1).to_s

      @data[:AP] =
        if check_string
          { N: { :Off => app.checkbox_off(self), radio_index => app.checkbox_on(self) },
            R: { :Off => app.checkbox_off_over(self), radio_index => app.checkbox_on_over(self) },
            D: { :Off => app.checkbox_off_down(self), radio_index => app.checkbox_on_down(self) } }
        else
          { N: { :Off => app.radio_off(self), radio_index => app.radio_on(self) },
            R: { :Off => app.radio_off_over(self), radio_index => app.radio_on_over(self) },
            D: { :Off => app.radio_off_down(self), radio_index => app.radio_on_down(self) } }
        end
      @data[:AS] = radio_index === @value ? radio_index.to_sym : :Off

      if check_string
        # right now, Adobe is replacing our appearance AP content stream with its own defaults
        # and uses ZaDB (ZapfDingBats) for its font. Using '4', which corresponds to 
        # checkmark for that font would render the radio button as a checkmark
        @data[:MK] = @data[:MK] || {}
        @data[:MK][:CA] = PDF::Core::LiteralString.new('4')
      end

      nil
    end

    protected

    def default_options
      super.merge(FT: :Btn, Ff: 32_768)
    end
  end
end
