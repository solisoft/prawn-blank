# frozen_string_literal: true

class Prawn::Blank::Form < Hash
  def initialize(document)
    super()
    self[:Fields] = []
    zadb_ref = document.ref!(
      Name: :ZaDb,
      Subtype: :Type1,
      BaseFont: :ZapfDingbats,
      Type: :Font
    )
    helv_ref = document.ref!(
      Name: :Helv,
      Subtype: :Type1,
      BaseFont: :Helvetica,
      Type: :Font
    )
    self[:DR] = {
      Font: {
        ZaDb: zadb_ref,
        Helv: helv_ref
      }
    }
    self[:DA] = PDF::Core::LiteralString.new('/Helv 0 Tf 0 g')
  end

  def add_resource(type, name, dict)
    self[:DR][type] ||= {}
    self[:DR][type][name] ||= dict
  end

  def add_resources(hash)
    hash.each do |type, names|
      if names.is_a? Array
        self[:DR][type] ||= []
        self[:DR][type] = self[:DR][type] | names
      else
        names.each do |name, dict|
          add_resource(type, name, dict)
        end
      end
    end
  end

  def add_field(field)
    self[:Fields] << field
  end
end
