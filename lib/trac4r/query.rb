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

require 'xmlrpc/client'

module Trac
  class Query
    def initialize url,user,pass
      if user && pass
        url = url.sub 'xmlrpc','login/xmlrpc'
      end
      uri = URI.parse(url)
      use_ssl = (uri.scheme == 'https') ? true : false
      @connection = XMLRPC::Client.new(uri.host,
                                       uri.path,
                                       uri.port,
                                       nil,
                                       nil,
                                       user,
                                       pass,
                                       use_ssl,
                                       nil)
    end
    
    def query command, *args
      begin
        return @connection.call(command,*args)
      rescue => e
        if e.message =~ /HTTP-Error/
          errorcode = e.message.sub 'HTTP-Error: ',''
          raise TracException, "#{errorcode}"
        else
          raise
        end
      end
    end
  end
end
