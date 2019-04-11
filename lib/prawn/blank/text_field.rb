# frozen_string_literal: true

class Prawn::Blank::TextField < Prawn::Blank::Field
  # attr_accessor :text_style

  def finalize(document)
    # render this field

    # :DA is set from text_style in field_base.rb
    # We also need to add the Font resource to DR in the form.

    if text_style
      text_style.font_instance.add_to_current_page(text_style.font_subset)
      font_ref = document.state.page.fonts[text_style.font_identifier]
      document.acroform.add_resources(
        Font: {
          text_style.font_identifier => font_ref
        }
      )
    end

    # Variable text fields should not have appearance streams.
    # See the "Variable Text" section in the PDF reference.

    # app = appearance || document.default_appearance

    # @data[:AP] = {
    #   N: app.text_field_default_appearance(self)
    # }
    # @data[:AS] = :N

    nil
  end

  protected

  def default_options
    super.merge(FT: :Tx)
  end
end
