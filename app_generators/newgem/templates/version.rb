module <%= module_name %> #:nodoc:
  module VERSION #:nodoc:
    MAJOR = <%= version[0] || '0' %>
    MINOR = <%= version[1] || '0' %>
    TINY  = <%= version[2] || '0' %>

    STRING = [MAJOR, MINOR, TINY].join('.')
  end
end
