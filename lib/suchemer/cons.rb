module Suchemer
  class Cons
    # A simple Lisp-style cons cell with basic list operations.
    # - A proper list is a chain of Cons ending in nil.
    # - A dotted pair is a Cons whose cdr is neither Cons nor nil.

    include Enumerable

    attr_accessor :car, :cdr

    def initialize(car = nil, cdr = nil)
      @car = car
      @cdr = cdr
    end

    # Build a proper list from given elements.
    def self.list(*elements)
      from_array(elements)
    end

    # Build a proper list from an Array or any Enumerable.
    def self.from_array(enum)
      arr = enum.respond_to?(:to_a) ? enum.to_a : Array(enum)
      node = nil
      arr.reverse_each { |e| node = new(e, node) }
      node
    end

    class << self
      alias from_enum from_array
      alias pair new
    end

    # Iterate over car values of a proper list. Stops before a dotted tail if any.
    def each
      return enum_for(:each) unless block_given?
      node = self
      while node.is_a?(Cons)
        yield node.car
        node = node.cdr
      end
      self
    end

    # Convert to a Ruby Array (drops a dotted tail if present).
    def to_a
      map { |x| x }
    end

    # Number of elements in the proper part of the list.
    def size
      count
    end
    alias length size

    # Whether this is a proper list (cdr chain ends with nil).
    def proper_list?
      node = self
      while node.is_a?(Cons)
        node = node.cdr
      end
      node.nil?
    end

    # Whether this cons is a dotted pair (cdr is not Cons and not nil).
    def dotted_pair?
      !(@cdr.is_a?(Cons) || @cdr.nil?)
    end

    # Array-like element access. Supports negative indices via conversion.
    def [](index)
      unless index.is_a?(Integer)
        raise TypeError, "index must be Integer"
      end
      return to_a[index] if index.negative?

      i = 0
      node = self
      while node.is_a?(Cons) && i < index
        node = node.cdr
        i += 1
      end
      return nil unless node.is_a?(Cons)
      node.car
    end
    alias at []

    # Return the last element of a proper list. For a dotted pair chain,
    # returns the cdr of the final cons.
    def last
      node = self
      prev = nil
      while node.is_a?(Cons)
        prev = node
        node = node.cdr
      end
      # node is now either nil (proper list) or dotted tail
      if node.nil?
        prev&.car
      else
        # dotted tail value
        node
      end
    end

    # Return a new proper list with same elements in reverse order.
    # Raises ArgumentError if not a proper list.
    def reverse
      raise ArgumentError, "reverse requires a proper list" unless proper_list?
      acc = nil
      node = self
      while node.is_a?(Cons)
        acc = Cons.new(node.car, acc)
        node = node.cdr
      end
      acc
    end

    # Append another list/array to this list, returning a new list.
    # Accepts: Cons, Array, or nil. Requires this to be a proper list.
    def append(other)
      raise ArgumentError, "append requires a proper list on the left-hand side" unless proper_list?

      rhs =
        case other
        when nil
          nil
        when Cons
          other
        when Array
          Cons.from_array(other)
        else
          raise ArgumentError, "append accepts Cons, Array, or nil"
        end

      # Copy this list and attach rhs at the end.
      return rhs if self.nil?
      # copy head
      head = Cons.new(@car, nil)
      dst = head
      src = @cdr
      while src.is_a?(Cons)
        dst.cdr = Cons.new(src.car, nil)
        dst = dst.cdr
        src = src.cdr
      end
      dst.cdr = rhs
      head
    end

    # Structural equality. Compares element-wise for proper lists.
    # Also supports comparison with Arrays.
    def ==(other)
      case other
      when Cons
        a = self
        b = other
        while a.is_a?(Cons) && b.is_a?(Cons)
          return false unless a.car == b.car
          a = a.cdr
          b = b.cdr
        end
        a.nil? && b.nil?
      when Array
        to_a == other
      else
        false
      end
    end

    # Pretty print like Lisp: (1 2 3) or (1 . 2)
    def to_s
      parts = []
      node = self
      while node.is_a?(Cons)
        parts << node.car.inspect
        node = node.cdr
      end
      if node.nil?
        "(" + parts.join(" ") + ")"
      else
        # dotted tail
        "(" + parts.join(" ") + " . #{node.inspect})"
      end
    end
    alias inspect to_s

    # Convenience aliases for lispy naming
    alias head car
    alias tail cdr
  end
end
