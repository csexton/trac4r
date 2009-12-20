module Trac
  # This class represents a ticket as it is retrieved from the database
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
