trac4r: Ruby wrapper for the Trac XML-RPC API
=============================================

This module wraps the XMLRPC interface of trac (trac.edgewall.org/) into a ruby library. You can now easily access trac from any ruby application without having to handle all the (trivial) XMLRPC calls.
For more information on the Trac XML-RPC see the [plugin's page on trac-hacks.com](http://trac-hacks.org/wiki/XmlRpcPlugin#UsingfromRuby)

Thanks to the original author, Niklas Cathor, who has done most of the work.


Examples
==========

Example (receive list of opened tickets):

    require 'trac4r/trac'
    trac = Trac.new "http://dev.example.com/trac/my_awesome_project"
    trac.tickets.list :include_closed => false #=> [7,9,3,5,14,...]

Receive one single ticket

    ticket = trac.tickets.get 9 #=> #<Trac::Ticket:0xb76de9b4 ... >
    ticket.summary #=> 'foo'
    ticket.description #=> 'bar'

See documentation for Trac::Ticket for what methods you can call on ticket.

Create a new ticket

    trac.tickets.create "summary", "description", :type => 'defect', :version => '1.0', :milestone => 'bug free' #=> 10

summary and description are required, the rest is optional. It can be one of the following: :severity, :milestone, :status, :type, :priority, :version, :reporter, :owner, :cc, :keywords

