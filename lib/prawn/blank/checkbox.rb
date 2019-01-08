# frozen_string_literal: true

class Prawn::Blank::Checkbox < Prawn::Blank::Field
  def checked
    @data[:AS] == :Yes
  end

  def checked=(value)
    if value
      @data[:AS] = :Yes
      @data[:V] = :Yes
    else
      @data[:AS] = :Off
      @data[:V] = :Off
    end
  end

  def finalize(document)
    # render this field

    app = appearance || document.default_appearance

    @data[:AP] = { N: { Off: app.checkbox_off(self), Yes: app.checkbox_on(self) },
                   R: { Off: app.checkbox_off_over(self), Yes: app.checkbox_on_over(self) },
                   D: { Off: app.checkbox_off_down(self), Yes: app.checkbox_on_down(self) } }
    nil
  end

  protected

  def default_options
    super.merge(FT: :Btn)
  end
end
