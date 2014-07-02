require 'bitcoin'
require 'yaml'

Bitcoin.network = :testnet3
gaston_config = ".config/gaston.yml"
gaston_example = ".config/example.yml"

def generate_complete_set
	key = Bitcoin::generate_key
	address = Bitcoin::pubkey_to_address(key[1])
	if Bitcoin::valid_address?(address)
		the_object = {}
		the_object[:private] = key[0]
		the_object[:public] = key[1]
		the_object[:address] = address
		the_object[:hash160] = Bitcoin.hash160_from_address(address)
		return the_object
	end
end

gaston_object = {}
gaston_object[:clef_1] = generate_complete_set
gaston_object[:clef_2] = generate_complete_set
gaston_object[:faucet] = {address: "msj42CCGruhRsFrGATiUuh25dtxYtnpbTx"}

text = {gaston: gaston_object}.to_yaml

if File.file?(gaston_config)
	puts text
else
	File.open(gaston_config, 'w') { |file| file.write(text) }
end

