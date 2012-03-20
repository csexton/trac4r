=begin
Copyright (c) 2008 Niklas E. Cathor <niklas@brueckenschlaeger.de>

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


DON'T USE IT IF YOU'RE AN ASSHOLE!
=end

module Trac
  class Tickets
    def initialize trac
      @trac = trac
    end
    
    # returns a list of all tickets (the ids), by performing two
    # queries, one for closed tickets, one for opened. use
    #   list :include_closed => false
    # to only get open tickets.
    def list options={ }
      include_closed = true
      include_closed = options[:include_closed] if !options[:include_closed].nil?
      tickets = query(:status => "!closed", :max => 0)
      tickets += query(:status => "closed", :max => 0) if include_closed
      return tickets
    end

    # Run an arbitrary ticket query
    # [+args+] a hash of options, each should use a symbol or string
    # as the key and a symbol/string or array of symbols/strings as the value.  If the
    # value starts with a +!+, it will be treated as a not equal.
    # Multiple values mean "or", as in any value may match
    def query(args)
      @trac.query("ticket.query",args_to_trac_args(args))
    end

    # like `list', but only gets closed tickets
    def list_closed
      query(:status => "closed", :max => 0)
    end
  
    # returns all tickets (not just the ids) in a hash
    # warning: to avoid heavy traffic load the results are cached
    # and will only be updated after 5 minutes. use
    #   get_all :cached_results => false
    # to avoid this.
    # other options:
    #   :include_closed - see Tickets#list for a description
    def get_all options={ }
      include_closed = options[:include_closed] || true
      cached_results = options[:cached_results] || true
      if(cached_results == true &&
         @cache_last_update &&
         @cache_last_update > Time.now - 300)
        return @cache
      end
      tickets = { }
      list(:include_closed => include_closed).each do |ticket|
        tickets[ticket] = get ticket
      end
      @cache = tickets
      @cache_last_update = Time.now
      return tickets
    end
    
    # fetch a ticket. Returns instance of Trac::Ticket
    def get id
      Ticket.load @trac.query("ticket.get",id)
    end
    
    # create a new ticket returning the ticket id
    def create summary,description,attributes={ },notify=false
      @trac.query("ticket.create",summary,description,attributes,notify)
    end
    
    # update ticket returning the ticket in the same orm as ticket.get
    def update id,comment,attributes={ },notify=false
      attr = {}
      attributes.each_pair do |key, value|
        unless(value.nil? || value.size == 0 || value.empty?)
          attr[key] = value
        end
      end
      @trac.query("ticket.update",id,comment,attr,notify)
    end
    
    # delete ticket by id
    def delete id
      @trac.query("ticket.delete",id)
    end
    
    # return the changelog as a list of tuples of the form (time,author,
    # field,oldvalue,newvalue,permanent). While the other tuples elements
    # are quite self-explanatory, the permanent flag is used to distinguish
    # collateral changes that are not yet immutable (like attachments, 
    # currently).
    def changelog ticket_id,w=0
      @trac.query("ticket.changeLog",ticket_id,w)
    end
    
    # returns a list of ids of tickets that have changed since `time'
    def changes time
      @trac.query("ticket.getRecentChanges",time)
    end
    
    # returns a list of attachments for the given ticket
    def attachments ticket_id
      @trac.query("ticket.listAttachments",ticket_id)
    end
    
    # returns the content of an attachment
    def get_attachment ticket_id,filename
      @trac.query("ticket.getAttachment",ticket_id,filename)
    end
    
    # adds an attachment to a ticket
    def put_attachment ticket_id,filename,description,data,replace=true
      @trac.query("ticket.putAttachment",ticket_id,filename,description,data,replace)
    end
    
    # deletes given attachment
    def delete_attachment ticket_id,filename
      @trac.query("ticket.deleteAttachment",ticket_id,filename)
    end
    
    # returns the actions that can be performed on the ticket
    def actions ticket_id
      @trac.query("ticket.getAvailableActions",ticket_id)
    end
    
    
    # returns all settings (possible values for status, version,
    # priority, resolution, component, type, severity or milestone)
    # as a hash in the form: { :status => ["assigned","closed",...], ... }
    # this method only gets the settings once per session. To update
    # them please refer to Tickets#get_settings
    def settings
      @settings || get_settings
    end
    
    
    # returns the settings in the same form as Tickets#settings, but
    # refreshes them every time we call it.
    def get_settings
      @settings = { }
      ['status','version','priority','resolution',
       'component','type','severity','milestone'].each do |setting|
        @settings[setting.to_sym] = @trac.query("ticket.#{setting}.getAll")
      end
      return @settings
    end

    private 

    def args_to_trac_args(args)
      trac_args = []
      args.each do |key,value|
        value = [value].flatten.map{ |x| x.to_s }.join('|')
        trac_args << key.to_s + (value =~ /^!/ ? "!=#{value[1..-1]}" : "=#{value}")
      end
      trac_args.join('&')
    end
    
  end
end
