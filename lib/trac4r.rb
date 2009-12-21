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

filedir = File.dirname(__FILE__)

require "trac4r/query"
require "trac4r/tickets"
require "trac4r/ticket"
require "trac4r/wiki"
require "trac4r/error"


# This module wraps the XMLRPC interface of
# trac (http://trac.edgewall.org/) into a ruby library.
# You can now easily access trac from any ruby
# application without having to handle all the 
# (trivial) XMLRPC calls.
#
# Example (receive list of opened tickets):
#   require 'trac4r/trac'
#   trac = Trac.new "http://dev.example.com/trac/my_awesome_project"
#   trac.tickets.list :include_closed => false #=> [7,9,3,5,14,...]
#
# Receive one single ticket
#   ticket = trac.tickets.get 9 #=> #<Trac::Ticket:0xb76de9b4 ... >
#   ticket.summary #=> 'foo'
#   ticket.description #=> 'bar'
# See documentation for Trac::Ticket for what methods you can call on ticket.
#
# Create a new ticket
#   trac.tickets.create "summary", "description", :type => 'defect', :version => '1.0', :milestone => 'bug free' #=> 10
# summary and description are required, the rest is optional. It can be one of the following:
# :severity, :milestone, :status, :type, :priority, :version, :reporter, :owner, :cc, :keywords
# 
module Trac
  # returns a new instance of Trac::Base
  def self.new url, user=nil,pass=nil
    Base.new url,user,pass
  end
  
  class Base
    attr_reader :wiki, :tickets, :user, :pass
    def initialize url,user,pass
      @user = user
      @pass = pass
      @url = url
      @url.gsub!(/\/$/,'')
      if @url.split('/').last != 'xmlrpc'
        @url = url+'/xmlrpc'
      end
      @connection = Query.new(@url,@user,@pass)
      @wiki = Wiki.new(@connection)
      @tickets = Tickets.new(@connection)
    end

    def query(command,*args)
      @connection.query(command,*args)
    end
    
    def api_version
      @connection.query("system.getAPIVersion")
    end
  end  
end
