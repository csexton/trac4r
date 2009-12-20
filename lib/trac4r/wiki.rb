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
  class Wiki
    def initialize trac
      @trac = trac
    end
    
    # returns a list of all pages
    def list
      @trac.query('wiki.getAllPages')
    end
    
    # convert a raw page to html (e.g. for preview)
    def raw_to_html content
      @trac.query('wiki.wikiToHtml',content)
    end
    
    # returns a whole page in HTML
    def get_html name
      @trac.query('wiki.getPageHTML',name)
    end
    
    # returns a whole page in raw format
    def get_raw name
      @trac.query('wiki.getPage',name)
    end    
    
    # sends a page. if the page doesn't exist yet it is created
    # otherwise it will be overwritten with the new content.
    def put name,content,attributes={ }
      @trac.query('wiki.putPage',name,content,attributes)
    end
    
    # deletes page with given name, returning true on success.
    def delete name
      @trac.query('wiki.deletePage',name)
    end
    
    # returns a list of all attachments of a page
    def attachments page
      @trac.query("wiki.listAttachments",page)
    end
    
    # returns the content of an attachment
    def get_attachment path
      @trac.query("wiki.getAttachment",path)
    end
    
    # uploads given `data' as an attachment to given `page'.
    # returns true on success.
    # unlike the XMLRPC-Call this method defaults `replace'
    # to false as we don't want to destroy anything.
    def put_attachment page,filename,description,data,replace=false
      @trac.query("wiki.putAttachmentEx",page,filename,description,data,replace)
    end
    
    # deletes attachment with given `path'
    def delete_attachment path
      @trac.query("wiki.deleteAttachment",path)
    end
  end
end
