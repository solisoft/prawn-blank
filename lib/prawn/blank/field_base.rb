# frozen_string_literal: true

class Prawn::Blank::FieldBase < PDF::Core::Reference
  # see pdf reference for documentation
  FF_FLAGS = {
    readonly: 1,
    required: 2,
    no_export: 3,

    # for text fields
    multiline: 13,
    password: 14,

    # for buttons
    no_toggle_to_off: 15
  }.freeze

  class << self
    def field_attr_accessor(name, key, inheritable = true)
      class_eval <<EVAL
      def #{name}
        if #{inheritable.inspect} and !@data.key?(#{key.to_sym.inspect}) and self.parent?
          return self.parent.#{name}
        end
        @data[#{key.to_sym.inspect}]
      end
      def #{name}=(value)
        @data[#{key.to_sym.inspect}]=value
      end
      def delete_#{name}
        @data.delete #{key.to_sym.inspect}
      end
      def #{name}?
        if #{inheritable.inspect}
          @data.key?(#{key.to_sym.inspect}) or ( self.parent? and self.parent.#{name}?)
        else
          @data.key? #{key.to_sym.inspect}
        end
      end
      def own_#{name}?
        @data.key? #{key.to_sym.inspect}
      end
EVAL
    end

    def flag_accessor(name, bit, flag_name = 'flags')
      mask = (1 << (bit - 1))

      class_eval <<EVAL
      def #{name}
        (self.#{flag_name} || 0) & #{mask.inspect}
      end

      alias #{name}? #{name}

      def #{name}=(value)
        if value
          self.#{flag_name} = (self.#{flag_name} || 0) | #{mask.inspect}
        else
          self.#{flag_name} = (self.#{flag_name} || 0) & ~#{mask.inspect}
        end
      end
EVAL
    end
  end

  field_attr_accessor :rect, :Rect, false
  field_attr_accessor :parent, :Parent, false
  field_attr_accessor :children, :Kids, false
  field_attr_accessor :type, :FT
  field_attr_accessor :aflags, :F
  field_attr_accessor :flags, :Ff
  field_attr_accessor :name, :T, false
  field_attr_accessor :fullname, :TU, false
  field_attr_accessor :value, :V
  field_attr_accessor :default_value, :DV
  field_attr_accessor :text_style, :DA
  field_attr_accessor :_app, :AP
  field_attr_accessor :border_style, :BS
  field_attr_accessor :style, :MK
  field_attr_accessor :page, :P
  field_attr_accessor :options, :Opt

  flag_accessor :invisible, 1, 'aflags'
  flag_accessor :hidden, 2, 'aflags'
  flag_accessor :print, 3, 'aflags'
  flag_accessor :no_zoom, 4, 'aflags'

  flag_accessor :readonly, 1
  flag_accessor :required, 2
  flag_accessor :no_export, 3

  flag_accessor :multiline, 13
  flag_accessor :password, 14
  flag_accessor :no_toggle_to_off, 15

  flag_accessor :combo, 18
  flag_accessor :editable, 19

  alias _parent= parent=

  def parent=(p)
    parent.children.delete(self) if parent?
    p.children ||= []
    p.children << self
    self._parent = p
  end

  def appearance
    return @appearance if @appearance
    return parent.appearance if parent?

    nil
  end

  attr_writer :appearance

  def leaf?
    !children?
  end

  def root?
    !parent?
  end

  def self.create(document, *args, &block)
    document.state.store.push(new(document.state.store.size + 1, *args, &block))
  end

  def self.from_ref(ref)
    result = new(ref.identifier)
    result.data = ref.data
    result
  end

  def initialize(id, *args)
    super(id, default_options)

    # okay, we print this annot by default
    self.print = true

    options = (args.last.is_a?(Hash) ? args.pop : {})
    options.each do |k, v|
      send "#{k}=".to_sym, v
    end

    yield self if block_given?
  end

  def width
    r = rect
    (r[2] - r[0]).abs
  end

  def width=(w)
    rect[2] = rect[0] + w
  end

  def height
    r = rect
    (r[3] - r[1]).abs
  end

  def height=(h)
    rect[3] = rect[1] + h
  end

  def at
    rect[0..1]
  end

  def at=(*args)
    x, y = args.flatten
    self.rect = [x, y, x + width, y - height]
  end

  def validate!
    raise 'Blank: Type must be :Annot ' if data[:Type] != :Annot
    raise 'Blank: Subtype must be :Annot ' if data[:Subtype] != :Widget

    if leaf?
      raise 'Blank: FT ( Field Type ) must be :Btn, :Tx, :Ch or :Sig ' unless %i[Btn Tx Ch Sig].include type
    end
  end

  def finalize(document); end

  def denormalize_color(color)
    s = color.size
    if s == 1 # gray
      return [0, 0, 0, color[0]]
    elsif s == 3 # rgb
      return Prawn::Graphics::Color.rgb2hex(color.map { |component| component * 255.0 })
    elsif s == 4 # cmyk
      return color.map { |component| component * 100.0 }
    end

    raise "Unknown color: #{color}"
  end

  protected

  def default_options
    {
      Type: :Annot,
      Subtype: :Widget,
      Rect: [0, 0, 0, 0]
    }
  end
end
