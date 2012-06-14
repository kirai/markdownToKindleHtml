markdownToKindleHtml
--------------------

### Requirements

  * Rdiscount -> https://github.com/rtomayko/rdiscount

### Kindle Markdown

Markdown superset dialect designed to facilitate ebook writing for Kindle Devices.

General grammar rules:

 * Page brake: \n\n\n -> <mbp:pagebreak/>
 
 * TOC (Enumerated list with links translates to a TOC): 

```html
      "###"Table of Contents"###"
       1.  [Chapter 1](#chap1)
       2.  [Chapter 2](#chap2)
       3.  [Chapter 3](#chap3)

     ---->
 
       <p><a name="TOC">
       <h3>Table of Contents</h3></a>
       </p> 
       <p><a href="#chap1"><h4>Chapter 1</h4></a></p> 
       <p><a href="#chap2"><h4>Chapter 2</h4></a></p> 
       <p><a href="#chap3"><h4>Chapter 3</h4></a></p> 
       <mbp:pagebreak/>
   </code>
```

 * Start chapter
     Link with no title will replace "href" with "name"     

```html
     [](#chap1) ## Chapter 1 ##

     ----->
     
     <a name="chap1"></a><h2>Chapter 1</h2>
```
 * Book cover?
