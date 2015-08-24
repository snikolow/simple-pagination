# Simple-Pagination

simple-pagination is small library based on Zephir. It's purpose is simply to format and output pagination listing with minimal configuration.

## Installation

In order to build use `simple-pagination` **Zephir** must be installed to your system.
* https://github.com/phalcon/zephir

If you already have zephir, simply locate the project directory and build the source.

```bash
cd ~/zephirtools
zephir build
```

If everything went okay, the you should see the following output:

```bash
Preparing for PHP compilation...
Preparing configuration file...
Compiling...
Installing...
Extension installed!
Add extension=zephirtools.so to your php.ini
Don't forget to restart your web server
```

Include `extension=zephirtools.so` to your `php.ini` file, reset your server and you are good to go.

## Configuration

This is a full list with options that you are free to override or use as they are defined. This library is configured to be compatible on the fly with `Twitter Bootstrap` so most of the configuration options should look familliar.

Name | Value | Description | Required

Name  | Value | Description | Required
------------- | ------------- | ----------- | -----------
baseUrl |  | Absolute URL to be added to all links generated | YES
totalItems | 0 | Total items from returned from resultset. | YES
page | 1 | Current page. 1 by default if not passed from config. | NO
perPage | 5 | Displayed items per page. | NO
displayItems | 2 | How many page numbers should be outputted from each side. | NO
listTagClass | pagination | Default classname that should be added to \<ul> | NO
fullTagOpen | \<nav\> | The opening tag placed on the left side of the entire result. | NO
fullTagClose | \<\/nav\> | The closing tag placed on the right side of the entire result. | NO
pageTagOpen | \<li\> | The opening tag for every item | NO
pageTagClose | \<\/li\> | The closing tag for every item. Should match **pageTagOpen** | NO
activeItemTagOpen | \<li class="active"> | Opening tag for selected (active) item | NO
activeItemTagClose | \<\/li\> | Closing tag for selected item. | NO
firstPageLabel | First | The text you would like to be displayed  in the "First" page link | NO
lastPageLabel | Last | The text you would like to be displayed in the "Last" page link | NO
nextPageLabel | \&gt; | The text you would like to be displayed in "next" page link | NO
prevPageLabel | \&lt; | The text you would like to be displayed in "previous" page link | NO
useTrailingSlash | true | Should a trailing slash be added right after **baseUrl** | NO
seoFriendlyStyle | false | By default a query string style is used when generating links. | NO
extraUrlParams | [] | Additional parameters to be added to each url. | NO

## Usage

1. Minimal

Place the following line at the top of your script.

```php
use ZephirTools\Pagination\Pagination;
```

Create some dummy data:

```php
$data = range(0,100);
```

Initialize pagination:

```php
$pagination = new Pagination(
	array(
    	'baseUrl' => 'http://domain.com/',
        'totalItems' => count($data),
    )
);
```

Now you can use 2 helper methods `getOffset()` and `getLimit()` to slice the necessary data. They could be used in `SQL` statement as well to limit your query properly.

```php
$result = array_slice($data, $pagination->getOffset(), $pagination->getLimit());
```

Dumping the following result, should return an output like this:

```
array (size=5)
  0 => int 0
  1 => int 1
  2 => int 2
  3 => int 3
  4 => int 4
```

By default, we display 5 items. And last, but not least, let's display our pagination by calling a helper method `getHtmlOutput()`

```php
print $pagination->getHtmlOutput();
```

The result of which would be the following output:

```html
<nav>
   <ul class="pagination">
      <li class="active"><a href="#">1</a></li>
      <li><a href="http://domain.com/?page=2">2</a></li>
      <li><a href="http://domain.com/?page=3">3</a></li>
      <li><a href="http://domain.com/?page=2">&gt;</a></li>
      <li><a href="http://domain.com/?page=21">Last</a></li>
   </ul>
</nav>
```

2. Advanced options

Let's say we build small e-commerce system. Having a filter to limit products page is a must. So, what if we want to pass an array with data coming from our filter, so we can build our links?

```php
// sample array holding our filter options
$filterData = array(
	'brand' => 'mybrand',
    'sizes' => array(
    	'M', 'L'
    ),
    'colors' => array(
    	'red', 'blue', 'green'
    )
);
```

Then we initialize pagination:

```php
$pagination = new Pagination(
	array(
    	'baseUrl' => 'http://domain.com/',
        'totalItems' => count($data),
        'extraUrlParams' => $filterData
    )
);
```

Printing `$pagination->getOutputHtml()` will return the following output (for the sake of easy understanding it's urldecoded)

```html
<nav>
   <ul class="pagination">
      <li class="active"><a href="#">1</a></li>
      <li><a href="http://domain.com?brand=mybrand&sizes[0]=M&sizes[1]=L&colors[0]=red&colors[1]=blue&colors[2]=green&page=2">2</a></li>
      <li><a href="http://domain.com?brand=mybrand&sizes[0]=M&sizes[1]=L&colors[0]=red&colors[1]=blue&colors[2]=green&page=3">3</a></li>
      <li><a href="http://domain.com?brand=mybrand&sizes[0]=M&sizes[1]=L&colors[0]=red&colors[1]=blue&colors[2]=green&page=2">&gt;</a></li>
      <li><a href="http://domain.com?brand=mybrand&sizes[0]=M&sizes[1]=L&colors[0]=red&colors[1]=blue&colors[2]=green&page=21">Last</a></li>
   </ul>
</nav>
```

## License
The code follows under MIT license, and a copy should be acompaning the code. May that not be the case, feel free to contact me.

## Contributing
This project should be considered to be still **in development**, any kind of contribution is more than welcome.
