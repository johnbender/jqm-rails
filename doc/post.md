# Rails and jQuery Mobile

The mobile web is huge and it's continuing to grow at an impressive rate. Internet browsing on mobile devices is doubling year over year as a percent of total web browsing according to some sources<sup>!!</sup>. Along with the massive growth of the mobile internet comes an impressive diversity of devices and browsers<sup>!!</sup>. It's not all WebKit, it's definitely not all iOS, and even when it is WebKit there are a vast array of implementation differences between browser APIs. As a result, making your applications cross platform and mobile ready is both important and difficult.

jQuery Mobile provides a quick start toward a mobile friendly application with semantic markup and the familiarity of jQuery. Rails provides an easy to use application environment for serving that markup and managing the data that backs it. By and large they work together flawlessly to create an awesome mobile experience but there are a few integration points that bear highlighting.

## Sample Application

All the examples and advice in this post are derived from the construction of a [sample application](https://github.com/johnbender/rails-jqm) that tracks the presence of employees in an office. It's obviously a simple application and complexity often shines a light in the little dark corners so if you've got suggestions please add them in the comments.

## Layout

There are a few important choices to make when setting up your Rails layouts for use with jQuery Mobile. Aside from including the right assets you must also consider your viewport meta tag configuration and jQuery Mobile page setup.

### Includes/Meta Tag

The viewport meta tag has received a lot of attention recently because of the way that complexities of the way that the device viewpoert interacts with newer, higher resolution screens.

[pixel info](http://www.quirksmode.org/blog/archives/2010/04/a_pixel_is_not.html)

recommended meta tag

responsive js/wurfl for assets/meta tag single page websites

### Page Layout

page div in layout
dom cache config / page settings
content for

## Data Attributes

lots of data attributes
namespacing
`grep data- /opt/ruby/lib/ruby/gems/1.8/gems/jquery-rails-2.0.2/vendor/assets/javascripts/jquery_ujs.js`

## Form Validation

history issues
path differentiation
data-dom-cache
possibly addressing this in a later release https://github.com/jquery/jquery-mobile/issues/3227

## Debugging

