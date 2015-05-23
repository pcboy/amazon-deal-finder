# -*- encoding : utf-8 -*-
#
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                  Version 2, December 2004
#
#  Copyright (C) 2004 Sam Hocevar
#  14 rue de Plaisance, 75014 Paris, France
#  Everyone is permitted to copy and distribute verbatim or modified
#  copies of this license document, and changing it is allowed as long
#  as the name is changed.
#  DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#
#
#  David Hagege <david.hagege@gmail.com>
#

# list of products you want to watch
# Support any keyword or an amazon product id
PRODUCTS = ['ricoh']

TO_EMAIL =  'your@email.com'
FROM_EMAIL = 'amazon_deal@deal.com'

mail_config = { :address              => "localhost",
                :port                 => 25,
                :authentication       => 'none',
                :enable_starttls_auto => false  }



Mail.defaults do
  delivery_method :smtp, mail_config
end
