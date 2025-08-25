## Suchemer
sucheme in Ruby (original: 2010/12/21-). This repo now includes a simple Lisp-style Cons implementation.

### Cons usage
```ruby
require "suchemer/cons"
include Suchemer

lst = Cons.list(1,2,3)  # => (1 2 3)
lst.to_a                 # => [1,2,3]
lst[1]                   # => 2
lst.reverse              # => (3 2 1)
lst.append([4,5])        # => (1 2 3 4 5)

Cons.new(1, 2)           # => (1 . 2)
```

See specs under `spec/` for more.

