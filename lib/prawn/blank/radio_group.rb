# frozen_string_literal: true

module Prawn::Blank
  class RadioGroup < Field
    def finalize(_document)
      # @data[:DA] = "/F1.0 9 Tf 0.000 1.000 0.000 rg"
      # @data[:V] = :Off
      @data.delete :Rect
    end

    protected

    def default_options
      super.merge(FT: :Btn, Ff: 32_768)
    end
  end
end
