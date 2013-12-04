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
