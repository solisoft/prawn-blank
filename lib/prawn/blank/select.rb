# frozen_string_literal: true

class Prawn::Blank::Select < Prawn::Blank::Field
  def initialize(*args)
    super
    self.combo = true
  end

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

    # app = appearance || document.default_appearance

    # @data[:AP] = { N: app.text_field(self) }
    # @data[:AS] = :N

    # document.acroform.add_resources(da.data[:Resources])

    nil
  end

  protected

  def default_options
    super.merge(FT: :Ch)
  end
end
