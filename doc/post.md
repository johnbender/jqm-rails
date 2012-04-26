# Rails and jQuery Mobile

The mobile web is huge and it's continuing to grow at an impressive rate. Internet browsing on mobile devices is doubling year over year as a percent of total web browsing according to some sources<sup>!!</sup>. Along with the massive growth of the mobile internet comes an impressive diversity of devices and browsers<sup>!!</sup>. It's not all WebKit, it's definitely not all iOS, and even when it is WebKit there are a vast array of implementation differences between browser APIs. As a result, making your applications cross platform and mobile ready is both important and difficult.

jQuery Mobile provides a quick start toward a mobile friendly application with semantic markup and the familiarity of jQuery. Rails provides an easy to use application environment for serving that markup and managing the data that backs it. By and large they work together flawlessly to create an awesome mobile experience but there are a few integration points that bear highlighting.

This post assumes that you have some basic knowledge of how jQuery Mobile works including an understanding of what `data-*` attributes are and how they are used to create jQuery Mobile pages, headers and content blocks. For a quick introduction to the basics there's a great article by Shaun Dunne at [ubelly.com](http://www.ubelly.com/2012/02/jquery-mobile-101/) that covers everything necessary for this article.

## Sample Application

All the examples and advice in this post are derived from the construction of a [sample application](https://github.com/johnbender/jqm-rails) that tracks the presence of employees in an office. It's obviously a simple application and complexity often shines a light in the little dark corners so if you've got suggestions please add them in the comments. Otherwise, the `README` has detailed setup instructions for the application if you want to play around with it.

## Setting Up

The recommended includes for the `head` of your document looks something like:

```html
<link rel="stylesheet" href="$CDN/jquery.mobile.css"/>
<script src="$CDN/jquery-1.6.4.min.js"></script>
<script src="$CDN/jquery.mobile.js"></script>
```

Where `$CDN` is either your own content delivery network or `code.jquery.com/mobile/$VERSION/`. Rails, as of 3.1, uses the `jquery-rails` gem by default in a newly generated application's Gemfile and includes it via the asset pipeline. So your includes will actually take the form:

```html
<%= stylesheet_link_tag "application" %>
<%= javascript_include_tag "application" %>
<script src="$CDN/jquery.mobile.css"></script>
<script src="$CDN/jquery.mobile.js"></script>
```

since the jQuery JavaScript is rolled into the application include through the asset pipeline directive

```javascript
//= require jquery
```

At the time of this writing there is one issue with jQuery Mobile 1.1 and jQuery Core 1.7.2 and newly generated Rails `Gemfile` doesn't have a constraint on the jquery-rails gem version. So in your `Gemfile` it's a good idea to use `gem 'jquery-rails', '=2.0.1'`, which carries Core version 1.7.1 and is compatible with Mobile 1.1. After that the only thing left is to decide what you want to do with your viewport meta tag. The discusion about device scale and width is a long and complex one. The [quirksmode article](http://www.quirksmode.org/blog/archives/2010/04/a_pixel_is_not.html) is a good place to start, but the recommended `content` value for jQuery Mobile applications is:

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

## Layout

Aside from including the right assets and viewport meta tag you must also consider how you want to render your jQuery Mobile pages. The first and least complicated involves simply rendering all your view content into a page in the top level application layout (`app/views/layout/application.html.erb`):

```html
<body>
  <div data-role="page">
    <div data-role="header">
      <h1><%= yield :heading %></h1>
    </div>

    <div data-role="content">
      <%= yield %>
    </div>
  </div>
</body>
```

Here the main content of a view will be rendered into the `yield` call and a `content_for` block can be used to push bits of content else where. A simplified version of the users index at `app/views/users/index.html.erb` view would look something like:

```html
<% content_for :heading do %>
  All users
<% end %>

<ul data-role="listview" data-filter="true">
  <% @users.each do |user| %>
    <li><%= user.email %> - <%= user.status %></li>
  <% end %>
</ul>
```

As the complexity of your Rails application grows it's likely that the views will need to make more detailed alteration to their parent layouts that don't make sense as `content_for` yields. One approach is to create a jQuery Mobile page partial and use a render block (`app/views/shared/_page.html.erb`):

```html
<div data-role="page">
  <div data-role="header">
    <h1><%= h1 %></h1>
  </div>

  <div data-role="content">
    <%= yield %>
  </div>
</div>
```

And using it in a view would take the form (`app/views/shared/sample.html.erb`):

```html
<% render :layout => 'shared/page',
          :locals => { :h1 => "foo" } do %>
  <div>The Content</div>
<% end %>
```

This has the advantage of pushing the control down into the views a bit more and making the page configuration requirements more explicit by requiring the user provide the `:locals` values. As we'll see when we cover form validation being able to tightly control the configuration of the page elements with data attribute values is important.

## Data Attributes

jQuery Mobile makes heavy use of data attributes for annotating DOM elements and configuing how the library will opperate. As the use of data attributes becomes more and more common we decided, during the beta, that a namepsacing option would have a lot of value. Rails also makes fairly heavy use of data attributes for its unobtrusive javascript helpers though it doesn't appear from a simple `grep data- jquery_ujs.js` that there are any conflicts. If that changes you can alter jQuery Mobiles data attribute namespace with a simple addition `app/assets/javascripts/application.html.erb`:

```javascript
//= require jquery
//= require jquery_ujs
//= require .
$( document ).on( "mobileinit", function() {
  $.mobile.ns = "jqm-";
});
```

The `mobileinit` event fires before jQuery Mobile has enhanced the DOM and is generally where you configure with JavaScript. As a result it's important that the binding comes _after_ the inclusion of jQuery in the asset pipeline and before jQuery Mobile is included either in the pipeline or in the head of your document. With the above snippet in place the data attributes in our page partial would change to:

```html
<div data-jqm-role="page">
  <div data-jqm-role="header">
    <h1><%= h1 %></h1>
  </div>

  <div data-jqm-role="content">
    <%= yield %>
  </div>
</div>
```

If you are beginning a new application and you plan to use a couple libraries that rely on data attributes it might be better to start out with a namespace since changing it after the fact can be time intensive and/or error prone.

## Form Validation



history issues
path differentiation
data-dom-cache
possibly addressing this in a later release https://github.com/jquery/jquery-mobile/issues/3227

## Debugging

snippet to show rails exception output on page load failed


## footnotes

1. information about jquery-rails versions and jquery versions that work with jquery mobile
