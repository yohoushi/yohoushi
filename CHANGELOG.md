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
