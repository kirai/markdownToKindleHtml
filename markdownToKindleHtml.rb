#!/usr/bin/ruby
# -*- encoding : utf-8 -*-
#
# = markdownToKindle.rb translates a Markdown file to an Html file ready to be
#   used on a Kindle device. I use the output of this script as an input for 
#   kindlegen
#
# Kindle tags:
#   http://kindleformatting.com/book/files/KindleHTMLtags.pdf
#   https://kdp.amazon.com/self-publishing/help?topicId=A1B8OEIMUN0HFY
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

require 'rubygems'
require 'erb'
require 'optparse'
require 'rdiscount'

$styleSheets = { /markdown.*/  => 'http://kevinburke.bitbucket.org/markdowncss/markdown.css',
                 /bootstrap.*/ => 'http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css' }

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

    <link href="<%= styleSheet %>" rel="stylesheet"></link>
 
  </head>
  <body>
    <%= body %>
  </body>
</html>
EOF
)

# 
# == It manages loading markdown files, parsing them, 
#    and transforming to html ready to be used on a
#    Kindle device
#

class MkToKindle

  def loadMarkdownFile(filename)
    if !File.exists?(filename)
      puts "ERROR: #{filename} does not exist.\n"
      exit
    end 
    @markdownText = File.read(filename)
  end

  def getMarkdownText
    return @markdownText
  end

end


# 
# == It opens a markdown file, applies a template using ERB and outputs
#    the result to STDOUT
#
# * *Args*    :
#   - +filename+ -> markdown filename
#   - +template+ -> ERB template
#   - +options+  -> hash, options gathered by option parser
# * *Returns* :
#   - +html+ ->  string with the html output
#                FALSE if something bad happened
# * *Raises* :
#   - +ArgumentError+ -> 
#

def mkToHtml(filename, template, options)
  mkToKindleParser = MkToKindle.new
  mkToKindleParser.loadMarkdownFile(filename)
  fileContents = mkToKindleParser.getMarkdownText
  
  #Prepare body 
  body = RDiscount.new(fileContents, :smart, :filter_html)
  body = body.to_html

  #Prepare "title"
  #headers = body.scan(/(?<=<h\d>).*?(?=<\/h\d>)/)

  if headers
    title = headers.first 
  end

  # Try replacing with regex lamba combination
  #a = 'asdfasdf'
  #hash = {/(\d+) years/ => lambda { "#{$1.to_f * 2} a"},
  #        /Nadesiko/   => lambda {"Yamato"} }
 
  #p hash.find { |k, v| body =~ k }.to_a.last.call
   
  #Prepare "stylesheet"
  styleSheet = ''
  if options[:style]
    styleSheet = $styleSheets.find{ |n,v| options[:style] =~ n}.to_a.last
  end

  #Use ERB template engine to translate to html
  begin
    html = template.result(binding)
    return html
  rescue
    return FALSE
  end
end

#
# Main, parameter handling using OptionParser
#
if __FILE__ == $0

  #Parsing options
  options = {}

  begin
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

      opt.on("-h", "--help", "Shows the help") do
        puts opt_parser
      end
    end

    opt_parser.parse!
  rescue OptionParser::InvalidOption => e
    puts 'Error:'
    puts e 
    puts "\n"
    puts opt_parser
    exit 1
  end  

  # Parsing arguments
  unless ARGV.length >= 1
    puts opt_parser
  end

  # Translating each file to .html (It can translate many files at the same time)
  ARGV.each do |arg|
    html = mkToHtml(arg, template, options)
    puts html
  end

end
