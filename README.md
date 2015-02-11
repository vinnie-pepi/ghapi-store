Work4 Custom UIs
================

This repo helps us develop Work4 Custom UIs.  

# Background

Work4 is our internal outsourcing tool (http://work4.factual.com).  With it, we're able to outsource a myriad of work types such as drawing polygons, checking if places exist, and curating top records.  Instead of Work4 having intimate knowledge of how each of these work types behaves, Work4 decouples (most) work type views from itself, and mandates the client provide a template for Work4 to render, else default to a generic template provided by the system.  The current method of doing this is coding the template within a text box provided by Work4.  Though it confers nice benefits such as syntax highlighting, there are a few pain points with this approach.  THe first is not having version control.  The second is not being able to work in your own developer environment.      

# Usage

In order for your work template to show up in work4, you must have a uniquely named directory under the packages directory. Your "package" will consist of:
* an index.html.haml file (this is the only required component)
* a sample_data directory which can contain json or csv files used to preview the package you are creating
* a css directory to contain your *.css or *.sass files
* a javascripts directory to contain your *.js or *.coffee files
* a helpers directory where you can organize any ruby scripts that you've created

You may run a simple rake script to help you create this structure and populate it with samples: ```rake packages:new```

# Development

1.    Check out code base: ```git clone https://github.com/Factual/work4_custom_uis.git```
2.    Create a package directory with requirements. See above.
3.    Make sure you have some sample data in your sample_data directory. It's advisable to use json with one line for each task rather than arrays containing many tasks.
4.    Start building your UI (main page: index.html.haml), along with any helpers, js, css
5.    Commit and push to github

As you build your index.html.haml, you'll want to preview whate you've done. The best way to do this is to locally run the "renderer" rails application. You must have ruby, rails, and bundler installed on your system. However, if you do not wish to setup rails locally, you may create your package and navigate to:
https://work4.factual.com/admin/ui_packages, and preview from there. You will have to Force Sync to allow the work4 server to sync up with any code you have committed and pushed to github. 

### The Most Brief Introduction to HAML you'll ever read

HAML is syntatic ruby sugar for HTML.  (You should definitely reconsider your philosophical values if you are still using HTML.)  Here is a sample haml file: 

```

:ruby 
  x = 5 
  y = 6
  z = x + y

%h4= z 

- 5.times do |i|
  %p= i 

- content_for :javascripts do
  :javascript 
    alert("HEY"); 

```

First thing to point out: HAML is space sensitive.  Two spaces indented generally signify a 'closure'.  For example, the subsequent lines after :ruby, are interpreted as ruby code.  You'll notice that both those lines are indented with two spaces under the :ruby.  

Moving along, there is a %h4, and as you can probably guess is equivalent to the h4 html tag.   Notice there is no closing tag.

The next thing is the ruby for loop preceeded by a "-".  Even outside a :ruby block you can write ruby by preceeding the line with a "-".  If you instead preceed the line with an "=", that means print out onto the rendered HTML the value of that ruby statement that is executed. 

The last thing is the javascript section.  Not much to explain -- just remeber to include the HAML syntax for including javascript, as shown above.   




      


