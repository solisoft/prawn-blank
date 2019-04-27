# frozen_string_literal: true

require "prawn"

module Prawn
  module Blank
    autoload :Form, "prawn/blank/form"
    autoload :Style, "prawn/blank/style"
    autoload :FieldBase, "prawn/blank/field_base"
    autoload :Field, "prawn/blank/field"
    autoload :Appearance, "prawn/blank/appearance"
    autoload :TextField, "prawn/blank/text_field"
    autoload :Checkbox, "prawn/blank/checkbox"
    autoload :Select, "prawn/blank/select"
    autoload :Combo, "prawn/blank/combo"
    autoload :RadioGroup, "prawn/blank/radio_group"
    autoload :Radio, "prawn/blank/radio"
    autoload :TextStyle, "prawn/blank/text_style"

    def text_field(options = {})
      options[:at] = send(:map_to_absolute, options[:at]) if options[:at]
      f = TextField.create(self, options)
      yield(f) if block_given?
      add_field(f)
    end

    def select(options = {})
      options[:at] = send(:map_to_absolute, options[:at]) if options[:at]
      f = Select.create(self, options)
      yield(f) if block_given?
      add_field(f)
    end

    def checkbox(options = {})
      options[:at] = send(:map_to_absolute, options[:at]) if options[:at]
      f = Checkbox.create(self, options)
      yield(f) if block_given?
      add_field(f)
    end

    def radiogroup(options = {})
      f = RadioGroup.create(self, options)
      yield(f) if block_given?
      add_field(f)
    end

    def radio(options = {})
      options[:at] = send(:map_to_absolute, options[:at]) if options[:at]
      f = Radio.create(self, options)
      yield(f) if block_given?
      add_field(f)
    end

    def acroform
      state.store.root.data[:AcroForm] ||= ref!(Form.new)
      state.store.root.data[:AcroForm].data
    end

    attr_writer :default_appearance

    def default_appearance
      @default_appearance ||= Appearance.new(self)
    end

    protected

    def add_field(field)
      field.finalize(self)
      field.page = page.dictionary

      # Add field to AcroForm hash
      acroform.add_field(field) if field.root?

      # Add field to annots
      state.page.dictionary.data[:Annots] ||= []
      state.page.dictionary.data[:Annots] << field
      field
    end
  end

  def self.TextStyle(*args)
    Prawn::Blank::TextStyle.new(*args)
  end

  def self.BorderStyle(_doc, width, style = :S)
    {
      W: width,
      Type: :Border,
      S: style,
    }
  end

  def self.ColorStyle(doc, fill, stroke)
    {
      BC: doc.send(:normalize_color, stroke),
      BG: doc.send(:normalize_color, fill),
    }
  end
end

require "prawn/document"
Prawn::Document.extensions << Prawn::Blank
