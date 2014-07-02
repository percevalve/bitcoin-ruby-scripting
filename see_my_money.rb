require 'bitcoin'
require 'open-uri'
require 'gaston'
require 'pp'

gaston_config_file = ".config/gaston.yml"
webbtc_url = "http://test.webbtc.com"


Gaston.configure do |gaston|
  gaston.files = Dir[gaston_config_file]
end

# if RbConfig::CONFIG['host_os'] =~ /darwin/
# 	system("echo #{Gaston.clef_1.address} | pbcopy")
# 	system("open", webbtc_url)
# else
# 	puts webbtc_url
# 	puts "Your address is :"
# 	puts Gaston.clef_1.address
# end

address_info = JSON.parse(open("http://test.webbtc.com/address/#{Gaston.clef_1.address}.json").read)

address_info["transactions"].each {|l,k| 
	k["in"].each {|ll| p "#{ll["prev_out"]["hash"]} #{ll["prev_out"]["n"]}"} 
	p l
}