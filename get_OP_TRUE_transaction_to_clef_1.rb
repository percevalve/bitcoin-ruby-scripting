require 'bitcoin'
require 'open-uri'
require 'gaston'

Bitcoin.network = :testnet3

Gaston.configure do |gaston|
  gaston.files = Dir[".config/gaston.yml"]
end

#ruby sendback_to_faucet_from_regular_script.rb -transac=694c3d91dcb9c720362f65e361881138538d9befa62cacb89744c3d9faa389a9 -index=2 -v=0.9
#
 args = {
    transaction:  ARGV.find{|a| a[/transac=(.+)/, 1] } && $1,
    output_index: ARGV.find{|a| a[/index=(.+)/, 1] } && $1,
    value: ARGV.find{|a| a[/v=(.+)/, 1] } && $1,
}

# p Bitcoin.generate_address # returns address, privkey, pubkey, hash160

prev_hash = args[:transaction]
#prev_tx = Bitcoin::P::Tx.from_json(open("http://test.webbtc.com/tx/#{prev_hash}.json"))
# getting the info is just to have the value... we can do it manually
prev_tx_output_index = args[:output_index].to_i
puts value = args[:value].to_f
#puts value = prev_tx.outputs[prev_tx_output_index].value

tx = Bitcoin::Protocol::Tx.new

#the hash of the previous transaction needs to be packed in reverse apparently...
binary = [prev_hash].pack("H*").reverse
tx.add_in Bitcoin::Protocol::TxIn.new(binary, prev_tx_output_index, 0)

#to send to address
hash160 = Bitcoin.hash160_from_address(Gaston.clef_1.address)
pk =  [ ["76", "a9",    "14",   hash160,   "88",        "ac"].join ].pack("H*")
# the equivalent ruby method
# tx.add_out Bitcoin::Protocol::TxOut.value_to_address(value, "mn9CMv6V2h2Rj6DUWe9swF5ANkBedKNDNZ") # 

tx.add_out Bitcoin::Protocol::TxOut.new(value, pk)


a = "499602d2"
tx.in[0].script_sig = tx.in[0].script_sig = [ [ "04" , a, "04" , a, "04" , a, "04" , a].join ].pack("H*")

puts "json:\n"
puts tx.to_json # json
puts "\nhex:\n"
puts tx.to_payload.unpack("H*")[0] # hex binary

File.open(tx.hash + ".json", 'wb'){|f| f.print tx.to_json }
puts "use this json file for example with to push/send it to the network"
puts "ruby simple_network_monitor_and_util.rb send_tx=#{tx.hash}.json -n testnet3"

