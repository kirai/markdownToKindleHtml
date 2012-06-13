# -*- encoding : utf-8 -*-
require './../markdownToKindleHtml.rb' #TODO: how do I get rid of the "./../" ?

describe "testing general outputs" do
  it "should output html without style" do
    html = mkToHtml('../testData/japaneseCulture_YamatoNadesiko_Draft.md',
                     ERB.new("<html><%= body %></html>"),
                     {})
    html.should_not be_empty 
    html.should =~ /.*html.*/ 
  end
  
  #it "should output html with style" do
  #  
  #end

  #it "should output a PDF" do
  #
  #end

  #it "should output a .mobi file" do
  #
  #end
end

describe "MkToKindleHtml file handling methods" do
 
  before :each do
    @mkToKindleParser = MkToKindle.new
  end

  it "should exit if a file does not exist" do
    lambda { @mkToKindleParser.loadMarkdownFile("randomfile") }.should raise_error SystemExit
  end

  it "should load data from a file if it exists" do
    #@mkToKindleParser.loadMarkdownFile('../testData/japaneseCulture_YamatoNadesiko_Draft.md')
    #markdownText = @mkToKindlePaser.getMarkdownText
    #markdownText.should not be_empty
    @mkToKindleParser.loadMarkdownFile('../testData/japaneseCulture_YamatoNadesiko_Draft.md').getMarkdownText.should not be_empty
  end
end
