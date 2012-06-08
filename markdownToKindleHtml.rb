#
# Description: wraps a Markdown.pl html output into an html template
#              I use the output of this script as an input for kindlegen
#
# Usage: 
#       Input: files to be processed as parameters.
#       Output: standard output
#
# Example: ruby markdownToKindleHtml.rb testData/japaneseCulture_YamatoNadesiko_Draft.md
#
# TODO: use Rspec for testing,
#       handle input parameters/errors,
#       add option to add text-indent or not
#       (style it or not? bootstrap styling? markdown.css styling? 
#           let the user decide the desired output
#       Handle the cover of the book and the title
#       Error handling
#
# @kirai
#

require 'erb'
require 'rdiscount'

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

  fileContents = File.read(filename) 
 
  body = RDiscount.new(fileContents).to_html

  headers = body.scan(/(?<=<h\d>).*?(?=<\/h\d>)/)

  if headers
    title = headers.first 
  end

  puts template.result(binding)
 
end

ARGV.each do |arg|
  viewMarkdown(arg, template)
end
