Filtered Feed
=============
by [Aman King](http://www.amanking.com)

https://github.com/amanking/filtered-feed

FilteredFeed is an API to apply filters and transformations to an RSS or ATOM feed and to retrieve the feed items in JSON format. It is made available over HTTP as a JSON Web Service.

The Web Service is live on Heroku:

* http://filtered-feed.herokuapp.com/feed_items.json
* https://filtered-feed.herokuapp.com/feed_items.json

A typical use case is for rendering feeds directly in an HTML page using JavaScript. Live example: http://www.phantomtrail.com/phan-zone/phan-speak

Feed configuration is sent via query parameters. The JSON result is returned either directly or via JSONP if a callback parameter is passed. A jQuery JSONP call can be used to invoke the service conveniently.

jQuery example:

```javascript
var configuration = {
    source: 'https://www.facebook.com/feeds/page.php?format=atom10&id=150387955072012',
    replace: {
        content: [
            { xpath: '//hr' },
            { xpath: '//br' }
        ]
    },
    extract: {
        published: { regexp: '(\\d{4}-\\d{2}-\\d{2}[T\\s](?:\\d{2}:?){3})' }
    },
    exclude: {
        content: { regexp: 'slang%i%' },
        id: 'c1fd524234093255e6022a1bbcdef56c'
    }
};
// Using https://github.com/jaubourg/jquery-jsonp
$.jsonp({ 
    url: 'https://filtered-feed.herokuapp.com/feed_items.json',
    data: configuration,
    callbackParameter: "callback",
    success: function(data, status, xhr) {
        // some happy code
    },
    error: function(xhr, status, error) {
        // some sad code
    }
});
```

The response JSON structure will be like so:

```json
{
  "url": "https:\/\/www.facebook.com\/",
  "feed_url": "https:\/\/www.facebook.com\/feeds\/page.php?format=atom10&id=150387955072012",
  "title": "The Phantom Trail's Facebook Wall",
  "description": null,
  "last_modified": "2015-02-28T09:21:27.000+00:00",
  "entries": [
    {
      "author": "The Phantom Trail",
      "updated": "2015-02-28T09:21:27.000+00:00",
      "published": [ "2015-02-28T09:21:27" ],
      "id": "191511a2628b51d2ff391fb8912198cb",
      "url": "http:\/\/www.facebook.com\/permalink.php?story_fbid=676718945772241&id=150387955072012",
      "title": "",
      "categories": [],
      "content": "Live long and prosper, Mr. Spock...",
      "summary": null
    },
    {
      "author": "The Phantom Trail",
      "updated": "2015-02-17T11:30:43.000+00:00",
      "published": [ "2015-02-17T11:30:43" ],
      "id": "af85d04aacf4142aa7a830361ec01566",
      "url": "http:\/\/www.facebook.com\/permalink.php?story_fbid=671879052922897&id=150387955072012",
      "title": "The Phantom first walked the streets of the town like an ordinary man 79 years a...",
      "categories": [],
      "content": "The Phantom first walked the streets of the town like an ordinary man 79 years ago... First appearance in a daily newspaper strip on February 17, 1936. Happy birthday, Phantom! Keep walking!",
      "summary": null
    }
  ]
}
```

Apart from source, the input configuration basically consists of filter syntax:

``
<filter_type>: {
  <attribute_name>: <expression> | [<expression>, <expression>]
}
``

And the expression syntax is:

``
<simple_value> | { <expression_type>: <expression_specific_value> }
``

Provided filter types:

* *exclude:* any feed item that matches this filter will be excluded
* *extract:* the value of the specified attribute will be replaced with an array containing matches of the specified expression as applied on the original value
* *replace:* the value of the specified attribute will have parts of it replaced with a strikethrough (for images and links) or a blank (any other); the parts to be replaced with be specified by the expression

Provided expression types:

* *regexp:* regular expressions; groups are useful in the extract filter; regexp modifiers can be specified at the end within % signs, eg. %i% or %im%
* *xpath:* standard xpath expression syntax


For more details, please read through the specs and code.


License

   Copyright 2015 Aman King

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
