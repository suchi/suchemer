module Suchemer
  class Cons
	  attr_accessor :car, :cdr
	  def initialize(car, cdr) 
	    @car, @cdr = car, cdr
	  end
  end
end
