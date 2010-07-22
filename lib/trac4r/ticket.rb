module Trac
  # This class represents a ticket as it is retrieved from the database
  # Custom fields are detected and available via runtime-dispatched methods.  
  # See +method_missing+
  class Ticket
    attr_accessor(:id,          # Integer
                  :severity,    # String
                  :milestone,   # String
                  :status,      # String
                  :type,        # String
                  :priority,    # String
                  :version,     # String
                  :reporter,    # String
                  :owner,       # String
                  :cc,          # String
                  :summary,     # String
                  :description, # String
                  :keywords,    # String
                  :created_at,  # XMLRPC::DateTime
                  :updated_at)  # XMLRPC::DateTime
    # returns a new ticket
    def initialize id=0
      @id = id
      @severity=@milestone=@status=@type=@priority=@version=@reporter=@owner= @cc= @summary=@description=@keywords=""
    end
    
    # checks if all attributes are set
    def check
      instance_variables.each do |v|
        return false if instance_variable_get(v.to_sym).nil?
      end
      return true
    end

    # If a method call has no args and matches an instance variable,
    # we return its value.  e.g. if our tickets have a custom field
    # called +work_units+, then +some_ticket.work_units+ will
    # retrieve that value.  This currently only allows retrieval and
    # not updating the value.  Also note that you can retrieve a custom
    # field using "!" and this will silently return nil if the instance
    # variable didn't exist.  This is useful if some tickets just don't
    # have the custom field, but you don't wish to check for it
    def method_missing(sym,*args)
      method = sym.to_s
      method = method[0..-2] if method =~ /!$/
      if args.size == 0 && instance_variables.include?("@#{method}".to_sym)
        instance_eval("@" + sym.to_s)
      elsif method != sym.to_s
        nil
      else
        super.method_missing(sym,args)
      end
    end
    
    # loads a ticket from the XMLRPC response
    def self.load params
      ticket = self.new params[0]
      ticket.created_at = params[1]
      ticket.updated_at = params[2]
      attributes = params[3]
      attributes.each do |key,value|
        ticket.instance_variable_set("@#{key}".to_sym,value)
      end
      return ticket
    end
  end
end
