# frozen_string_literal: true

class Prawn::Blank::Field < Prawn::Blank::FieldBase
  # Returns the ZapfDingbats character code for the checkmark (between 3 and 8)
  def check_zapf_char
    check_char = check_string
    if check_char&.match?(%r{^&#1000\d;$})
      check_char = HTMLEntities.new.decode(check_char)
    end
    check_char = "✔" unless check_char&.length == 1
    check_zapf_char = (check_string.ord || 0) - 10000
    if check_zapf_char < 3 || check_zapf_char > 8
      check_zapf_char = 4
    end
    check_zapf_char.to_s
  end

  protected

  def get_dict
    base = super
    if appearance
      app = Prawn::Blank::Appearance.cast(appearance)

      app.font.instance_eval do
        @references[0] ||= register(0)
        @document.acroform.add_resource(
          :Font,
          identifier_for(0), @references[0]
        )
      end

      base.merge! app.apply_to(self)
    end
    base
  end
end
