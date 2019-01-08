# frozen_string_literal: true

class Prawn::Blank::TextField < Prawn::Blank::Field
  # attr_accessor :text_style

  def finalize(document)
    # render this field

    app = appearance || document.default_appearance

    @data[:AP] = { N: app.text_field(self) }
    @data[:AS] = :N

    nil
  end

  protected

  def default_options
    super.merge(FT: :Tx)
  end
end
