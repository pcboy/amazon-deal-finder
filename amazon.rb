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

require 'rest-client'
require 'mail'

require_relative 'config'

def get_deals_metadata
  params =
    {"requestMetadata"=>{"marketplaceID"=>"A1VC38T7YXB528",
                         "clientID"=>"goldbox"}, "page"=>1,
                         "dealsPerPage"=>100, "itemResponseSize"=>"NONE",
                         "queryProfile"=> {"featuredOnly"=>false,
                                           "dealTypes"=>["BEST_DEAL"]}}

  response =
    JSON.parse(RestClient.post 'http://www.amazon.co.jp/xa/dealcontent/v2/GetDealMetadata?nocache=1432363160409', params.to_json) 

  response['sortedDealIDs']
end

def get_deals(deals_ids)
  params =
    {"requestMetadata":{"marketplaceID":"A1VC38T7YXB528",
                        "clientID":"goldbox"},
                        "dealTargets": deals_ids.map {|x| {"dealID": x}},
                        "responseSize":"ALL","itemResponseSize":"NONE"}
  response =
    JSON.parse(RestClient.post 'http://www.amazon.co.jp/xa/dealcontent/v2/GetDeals?nocache=1432363160409', params.to_json) 
  response['dealDetails'].map {|k,v| v['url'] = product_page(v['impressionAsin']); v}
end

def product_page(impression_asin)
  "http://www.amazon.co.jp/gp/product/#{impression_asin}"
end

def mail_deal(deal, from_email, to_email)
  Mail.new do
    from     
    to       to_email
    subject  "[DEAL!] #{deal['title']}"
    body     "#{deal['url']}"
  end.deliver!
end

deals = get_deals(get_deals_metadata)

deals.map do |deal|
  PRODUCTS.map do |search|
    if deal['description'] =~ /#{search}/i ||
      deal['dealID'] == search ||
      deal['title'] =~ /#{search}/i
      mail_deal(deal, FROM_EMAIL, TO_EMAIL)
    end
  end
end
