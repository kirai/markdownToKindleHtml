#!/usr/bin/ruby
#
# = markdownToKindle.rb translates a Markdown file to an Html file ready to be
#   used on a Kindle device. I use the output of this script as an input for 
#   kindlegen
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
# Author:: @kirai
# License:: MIT License 
#

require 'erb'
require 'optparse'
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

# 
# == It opens a markdown file, applies a template using ERB and outputs
#    the result to STDOUT
#
# * *Args*    :
#   - +filename+ -> the number of apples
#   - +template+ -> ERB template
# * *Returns* :
#   - 
# * *Raises* :
#   - +ArgumentError+ -> 
#

def viewMarkdown(filename, template)

  if !File.exists?(filename)
    puts "ERROR: #{filename} does not exist.\n"
    exit
  end

  fileContents = File.read(filename) 
 
  body = RDiscount.new(fileContents).to_html

  headers = body.scan(/(?<=<h\d>).*?(?=<\/h\d>)/)

  if headers
    title = headers.first 
  end

  puts template.result(binding)
 
end

#
# Main, parameter handling using OptionParser
#
if __FILE__ == $0

  #Parsing options
  options = {}

  opt_parser = OptionParser.new do |opt|
    opt.banner = "Usage: #{$0} [-sh paramValue] inputMarkdown.md"
    opt.separator ""
    opt.separator "Example: #{$0} --sytle markdown.css input.md > output.html"
    opt.separator ""
    
    opt.on("-s", "--style style", "Stylesheet you want to apply to the output html,
                                     it can be markdown.css or bootstrap.css") do |style|
      if style =~ /(markdown)|(bootstrap)/
        options[:style] = style
      else
        puts opt_parser
      end
    end

    opt.on("-h","--help","Shows the help") do
      puts opt_parser
    end
  end

  opt_parser.parse!
  
  # Parsing arguments
  unless ARGV.length >= 1
    puts opt_parser
  end

  # Translating each file to .html
  ARGV.each do |arg|
    viewMarkdown(arg, template)
  end

end
