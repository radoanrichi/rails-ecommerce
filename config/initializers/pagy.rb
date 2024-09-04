# Optionally override some pagy default with your own in the pagy initializer
# Better user experience handled automatically
require 'pagy/extras/bootstrap'
require 'pagy/extras/overflow'
Pagy::DEFAULT[:limit] = 6 # items per page
Pagy::DEFAULT[:size]  = 6 # nav bar links
Pagy::DEFAULT[:overflow] = :last_page
