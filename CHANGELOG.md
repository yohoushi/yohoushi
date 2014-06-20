## 0.72.3 (2014/06/20)

Enhancement:

* Update Rails to 4.1.1, and also update related some gems
* Memory usage thresh of serverengine is configurable
* Worker interval is configurable
* Introduce lower_limit and upper_limit for graph parameter
* Add auto tagging option. Thanks @avvmoto !!!
* Run rake db:migrate automatically in bin/yohoushi command
* Add delete tagged graph button
* New API /api/yohoushi/graphs, tag and description for graph can be updated
* Update rspec to 3.0.1

Fixes:

* Fix form_to does not work when short_metrics: false
* Fix to restart serverengine by stop and start combo instead of USR1
* Fix performance issue, add INDEX for (type, path)

## 0.72.2 (2014/02/20)

Enhancement:

* Show &per= parameter on linked url
* Change default_per_page to 120 and max_per_page to 600 to suit with 3 columns
* And some enhancements

Fixes:

* Fix a bug which rack-streaming-proxy responses a broken chunked image data to HTTP/1.0 client
* Fix that interval sleep was not effectively working
* Fix so that worker can reboot if it receives USR1 or HUP
* Fix Go button of Tag page unescapes tag_list

## 0.72.1 (2013/12/04)

Enhancement:

* Update rails to 4.0.2 for sercurity fix

## 0.72.0 (2013/12/03)

Fixes:

* Fix yohoushi did not work with the GrowthForecast-head. Fix to support Transfer-Encoding: chunked (HTTP 1.1) by rack-streaming-proxy. 

## 0.62.4 (2013/10/02)

Enhancement:

* Add `Destory` button
* Add graph_parameter query parameters to links so that we can copy the URL and paste somewhere to see the same view later.
* Add a config to link to tree_graph, accordion.link_to_tree_graph. Default: true
* Add a config to expand the accordion from the root to the nodes of specified depth, accordion.initial_depth. Default: 1
 
Fixes:

* Fix tag autocomplete of <

## 0.62.3 (2013/08/24)

Fixes:

* Fix that the title of graph image disappears after thumbnal is chosen once
* Fix unicorn.god and serverengine.god not to care RAILS_ENV
* Fix the automatic rake assets:precompile

Enhancement:

* Reset `From` and `To` field when `term` field is selected
* require 'config/environments/production.rb' as default
* Add `kill` subcommand for bin/yohoushi
* bin/yohoushi traps the TERM signal to kill unicorn and serverengine 

Changes:

* Make smaller the font-size of the autocomplete form
* Create `acts_as_parameter_object` gem and use it

## 0.62.2 (2013/07/26)

Fixes:

* fix accordion.js to escape path
* fix travis
* fix REST API (bundle update multiforecast-client)

## 0.62.1 (2013/07/26)

Changes:

* Change LICENSE to The MIT License.

## 0.62.0 (2013/07/25)

First version
