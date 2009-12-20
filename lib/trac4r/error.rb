module Trac
  class TracException < Exception
    # Creates new TracException
    # 
    # [+http_error+] the error message, possibly mulit-line
    # [+host+] host on which we are connecting to Trac
    # [+port+] port we're using
    # [+path+] the path to the Trac API
    # [+method+] the XML RPC method being called
    # [+args+] the args (as an array) that were sent with the call
    def initialize(http_error,host,port,path,method,args)
      http_error = http_error.sub 'HTTP-Error: ',''
      if http_error =~ /\n/
        http_error.split(/\n/).each do |line|
          if line =~ /^\d\d\d/
            http_error = line
            break
          end
        end
      end
      @http_status,@http_message = http_error.split(/\s+/,2)
      @host = host
      @port = port
      @path = path
      @method = method
      @args = args
    end

    # Gives a more useful message for common problems
    def message
      if @http_status == '404'
        "Couldn't find Trac API at #{url}, check your configuration"
      elsif @http_status == '401'
        "Your username/password didn't authenticate, check your configuration"
      else
        "#{@http_message} (#{@http_status}) when trying URL http://#{@host}:#{@port}#{@path} and method #{@command}(#{@args.join('.')})"
      end
    end

    def url
      "http://#{@host}:#{@port}#{@path}"
    end
  end
end
