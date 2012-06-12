# -*- encoding : utf-8 -*-
require './../markdownToKindleHtml.rb' #TODO: how do I get rid of the "./" ?

describe "testing general outputs" do
  it "should output html without style" do
    html = mkToHtml('../testData/japaneseCulture_YamatoNadesiko_Draft.md', ERB.new("<html><%= body %></html>"), {})
    html.should_not be_empty 
    html.should =~ /.*html.*/ 
  end

  it "should output html with style" do
    
  end

  it "should output a PDF" do
  
  end

  it "should output a .mobi file" do

  end
end
