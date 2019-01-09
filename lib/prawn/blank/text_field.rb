# frozen_string_literal: true

class Prawn::Blank::TextField < Prawn::Blank::Field
  # attr_accessor :text_style

  def finalize(_document)
    # render this field

    # app = appearance || document.default_appearance

    # @data[:AP] = {
    #   N: app.text_field(self, 'ffffcc'),
    #   R: app.text_field(self, 'ccffff')
    # }
    # @data[:AS] = :Off

    nil
  end

  protected

  def default_options
    super.merge(FT: :Tx)
  end
end
