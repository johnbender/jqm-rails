# Rails and jQuery Mobile

The mobile web is huge and it's continuing to grow at an impressive rate. Internet browsing on mobile devices is doubling year over year as a percent of total web browsing according to some sources<sup>!!</sup>. Along with the massive growth of the mobile internet comes an impressive diversity of devices and browsers<sup>!!</sup>. It's not all WebKit, it's definitely not all iOS, and even when it is WebKit there are a vast array of implementation differences between browser APIs. As a result, making your applications cross platform and mobile ready is both important and difficult.

jQuery Mobile provides a quick start toward a mobile friendly application with semantic markup and the familiarity of jQuery. Rails provides an easy to use application environment for serving that markup and managing the data that backs it. By and large they work together flawlessly to create an awesome mobile experience but there are a few integration points that bear highlighting.

This post assumes that you have some basic knowledge of how jQuery Mobile works including an understanding of what `data-*` attributes are and how they are used to create jQuery Mobile pages, headers and content blocks. For a quick introduction to the basics there's a great article by Shaun Dunne at [ubelly.com](http://www.ubelly.com/2012/02/jquery-mobile-101/) that covers everything necessary for this article.

Additionally, all the examples and advice in this post are derived from the construction of a [sample application](https://github.com/johnbender/jqm-rails) that tracks the presence of employees in an office. It's obviously a simple application and complexity often shines a light in the little dark corners so if you've got suggestions please add them in the comments. Otherwise, the `README` has detailed setup instructions for the application if you want to play around with it.

## Setting Up

The recommended includes for the `head` of a non-Rails jQuery Mobile document looks something like:

```html
<link rel="stylesheet" href="$CDN/jquery.mobile.css"/>
<script src="$CDN/jquery-1.6.4.min.js"></script>
<script src="$CDN/jquery.mobile.js"></script>
```

Where `$CDN` is either your own content delivery network or `//code.jquery.com/mobile/$VERSION/`. Rails, as of 3.1, uses the `jquery-rails` gem by default in a newly generated application's Gemfile and includes it via the asset pipeline. So your includes will actually take the form:

```html
<%= stylesheet_link_tag "application" %>
<%= javascript_include_tag "application" %>
<script src="$CDN/jquery.mobile.css"></script>
<script src="$CDN/jquery.mobile.js"></script>
```

Since the jQuery JavaScript is rolled into the application include through the asset pipeline with the directive

```javascript
//= require jquery
```

At the time of this writing there is one issue with jQuery Mobile 1.1 and jQuery Core 1.7.2 and a newly generated Rails `Gemfile` doesn't have a constraint on the jquery-rails gem version. So in your `Gemfile` it's a good idea to use `gem 'jquery-rails', '=2.0.1'`, which carries jQuery Core version 1.7.1 and is compatible with jQuery Mobile 1.1. After that the only thing left is to decide what you want to do with your viewport meta tag. The discussion about device scale and width is a long and complex one. The [quirksmode article](http://www.quirksmode.org/blog/archives/2010/04/a_pixel_is_not.html) is a good place to start, but the recommended tag for jQuery Mobile applications is:

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

## Layout

Aside from including the right assets and viewport meta tag you must also consider how you want to render your jQuery Mobile pages. The first and least complicated involves simply rendering all your view content into a `data-role=page` div element in the top level application layout (`app/views/layout/application.html.erb`):

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

Here the main content of a view will be rendered into the `yield` call and a `content_for` block can be used to push bits of content elsewhere. A simplified version of the users index at `app/views/users/index.html.erb` view would look something like:

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

This at least reduces the burden on the view itself leaving a large chunk of the work in keeping the pages consistent to the layout. As the complexity of your Rails application grows it's likely that the views will need to make more detailed alteration to their parent layouts that don't make sense as `content_for` yields. One approach is to create a jQuery Mobile page partial and use a render block (`app/views/shared/_page.html.erb`):

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

This has the advantage of pushing the control down into the views a bit more and making the page configuration requirements more explicit by requiring the user provide the `:locals` values. As we'll see, being able to tightly control the configuration of the page elements with data attribute values is important.

## Form Validation

jQuery Mobile's support for caching multiple pages in an html document can cause issues for Rails form validation and really any sequence of actions that can navigate to the same URL many times in a row. By default the pages that exist in the html document will be removed when navigating away from them but in general the framework tries to source content and views locally where possible. A simple example will illustrate:

```html
<div data-role="page" data-url="/foos">
  <div data-role="content">
    <a href="/bars">Go to Bars</a>
    All the Foos
  </div>
</div>

<div data-role="page" data-url="/bars">
  <div data-role="content">
    <a href="/bars">Go to Bars</a>
    All the Bars
  </div>
</div>
```

Assuming the first page is the current active page and DOM caching is turned on, clicking one of the `/bars` links will navigate to the page that already exists in the DOM from that url (the `data-url` is added by the framework to identify where content came from). As a consequence when clicking the `/bars` link on the `/bars` page it's effectively a no-op. This is important in rails because invalid form submissions render the `new` view consistently under the index path (`app/controllers/users_controller.rb`).

```ruby
def create
  @user = User.new(params[:user])

  if @user.save
    redirect_to root_url
  else
    # /users == /users/new
    render :new
  end
end
```

On validation failure the content of `/users` is effectively identical to `/users/new` save for the possible addition of the error message markup. The problem is that the page content for `/users` also has a form that submits to `/users` as its action which is the aforementioned noop.

The solution we normally recommend is to add `data-ajax=false` on the form which will prevent the framework from hijacking the submit. Unfortunately that also means it won't pull the content and apply an animation/transition. One quick way to get around the problem and retain the nice transitions is to differentiate the action path with a url parameter with a helper (`app/helpers/application_helper.rb`).

```ruby
# NOTE severely pushing the "clever" envelope here
def differentiate_path(path, *args)
  attempt = request.parameters["attempt"].to_i + 1
  args.unshift(path).push(:attempt => attempt)
  send(*args)
end
```

As noted this is probably a bit too clever (pejorative form), but it handles differentiating parametrized or unparameterized rails path and url helpers by adding an attempt query parameter. In use as the `:url` hash parameter to the `form_for` and `form_tag` helpers it looks like:

```ruby
# new form
:url => differentiate_path(:users_path)

# edit form
:url => differentiate_path(:user_path, @user)
```

For each new submission it will increment the parameter value and signal to jQuery Mobile that the path and the content are different. In addition you will want to annotate your form page with `data-dom-cache=true` so that it preserves the previous form submission page contents for a sane back button experience (easier with the `_page` partial). Otherwise jQuery Mobile will reap the previous form validation failure pages from the DOM and try to reload the requested url in the history stack. If that happens to be `/users?attempt=3` the content won't be the submission form but rather a list of the users or something else if that url requires validation. By preserving the pages the back button will simply let them traverse backwards through their submission failures.

## Data Attributes

jQuery Mobile makes heavy use of data attributes for annotating DOM elements and configuring how the library will operate. During beta we came to the consensus that data attribute use was becoming more and more common and decided that a namespacing option would have a lot of value. Rails also makes fairly heavy use of data attributes for its unobtrusive javascript helpers though it doesn't appear from a simple `grep data- jquery_ujs.js` that there are any conflicts. If that changes you can alter jQuery Mobiles data attribute namespace with a simple addition to `app/assets/javascripts/application.html.erb`:

```javascript
//= require jquery
//= require jquery_ujs
//= require .
$( document ).on( "mobileinit", function() {
  $.mobile.ns = "jqm-";
});
```

The `mobileinit` event fires before jQuery Mobile has enhanced the DOM and is generally where you configure the framework with JavaScript. As a result it's important that the binding comes _after_ the inclusion of jQuery in the asset pipeline and before jQuery Mobile is included either in the pipeline or in the head of your document. With the above snippet in place the data attributes in our page partial would change to:

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

## Debugging

Tooling for mobile web development is still evolving and though Weinre and Adobe Shadow present intersecting opportunities to debug CSS, markup, and JavaScript we still get server side errors. jQuery Mobile, being unaware of the environment in which it's working must report a server error in a user friendly fashion. As a result it swallows the Rails stack traces we've come to know and love and just displays an error alert. By binding the special `pageloadfailed` event we can replace the DOM content with the stack trace when one occurs (`app/assets/javascripts/debug/pagefailed.js.erb`)

```javascript
function onLoadFailed( event, data ) {
  var text = data.xhr.responseText,
      newHtml = text.split( /<\/?html[^>]*>/gmi )[1];
  $( "html" ).html( newHtml );
}

$( document ).on( "pageloadfailed", onLoadFailed);
```

To make sure that it only loads in development we can wrap that in a `<%= if Rails.env.development? %>` block and the asset pipeline will render the `erb` without the snippet in production/test <sup>!</sup>.

## A Fine Pair

If you're interested in taking this a bit further jQuery defines its constituent modules using AMD so integrating require.js into the asset pipeline and defining a meta module for just the parts you want is one way to reduce the wire weight of the include. Also it's worth examining [WURFL](http://wurfl.sourceforge.net/) integration through the [gem](http://rubydoc.info/gems/wurfl/1.3.6/frames) of the same name if you are creating a mobile version of an existing website and you want to redirect users properly. Otherwise, Rails and jQuery Mobile make an exceptionally productive team for building mobile web applications.

### Notes

1. Thanks to some helpful attendants of my RailsConf talk for informing me about using erb in the asset pipeline!
2. If you find errors please fork the [sample application repository](https://github.com/johnbender/jqm-rails/blob/master/doc/post.md), make the alteration to `doc/post.md` and submit a pull request.
3. If you found the article worthwhile you can follow me on twitter [@johnbender](http://twitter.com/johnbender) or check out my personal blog at [johnbender.us](http://johnbender.us).
