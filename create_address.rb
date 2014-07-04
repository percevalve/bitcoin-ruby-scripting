require 'bitcoin'
require 'yaml'
require './learningtx'

Bitcoin.network = :testnet3
gaston_config = ".config/gaston.yml"
gaston_example = ".config/example.yml"
faucet_return_address = "msj42CCGruhRsFrGATiUuh25dtxYtnpbTx"

#if the port is not 18333, it seems that your are not using testnet... you should not do this !
if Bitcoin.network[:default_port] != 18333
  puts "This will store keys unencrypted on your drive, it is not safe to use it for 'real' keys."
  return false
end
gaston_object = {}
gaston_object[:clef_1] = generate_complete_set
gaston_object[:clef_2] = generate_complete_set
gaston_object[:faucet] = {address: faucet_return_address}

text = {gaston: gaston_object}.to_yaml

if File.file?(gaston_config)
  puts text
else
  #if the file exists already, print the result to the screen.
  File.open(gaston_config, 'w') { |file| file.write(text) }
end

