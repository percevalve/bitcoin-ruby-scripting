require 'gaston'

gaston_config_file = ".config/gaston.yml"
faucet_url = "https://tpfaucet.appspot.com"


Gaston.configure do |gaston|
  gaston.files = Dir[gaston_config_file]
end

if RbConfig::CONFIG['host_os'] =~ /darwin/
	system("echo #{Gaston.clef_1.address} | pbcopy")
	system("open", faucet_url)
else
	puts faucet_url
	puts "Your address is :"
	puts Gaston.clef_1.address
end