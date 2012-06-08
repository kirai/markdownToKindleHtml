#
# Description: wraps a Markdown.pl html output into an html template
#              I use the output of this script as an input for kindlegen
#
# Usage: put files to be processed as parameters.
#
# TODO: handle input parameters, add option to add text-indent or not
#       (style it or not? bootstrap styling? markdown.css styling?
#       Handle the cover of the book and the title
#
# @kirai
#

require 'erb'

template = ERB.new(<<EOF
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />  
    <title><%= title %></title>
    <style>
    <!--
      p { text-indent : 20px; }
    -->
    </style>
    <link href="http://kevinburke.bitbucket.org/markdowncss/markdown.css" rel="stylesheet"></link>
 
  </head>
  <body>
    <%= body %>
  </body>
</html>
EOF
)

def usage()
  puts 'Usage'
end

def viewMarkdown(filename, template)

  if !File.exists?(filename)
    puts "#{filename} does not exist."
  end

  title = ""
  body = File.read(filename) 
  
  puts template.result(binding)
 
end

ARGV.each do |arg|
  viewMarkdown(arg, template)
end
