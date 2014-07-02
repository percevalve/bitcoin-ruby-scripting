require 'bitcoin'
require 'open-uri'
require 'gaston'

Bitcoin.network = :testnet3

Gaston.configure do |gaston|
  gaston.files = Dir[".config/gaston.yml"]
end

#ruby sendback_to_faucet_from_regular_script.rb -transac=6353b0c6483b04740a5c6c9c1154d218c33b59f98fa6111748d5ef6725535b0b -index=0
#
 args = {
    transaction:  ARGV.find{|a| a[/transac=(.+)/, 1] } && $1,
    output_index: ARGV.find{|a| a[/index=(.+)/, 1] } && $1,
}

# p Bitcoin.generate_address # returns address, privkey, pubkey, hash160

prev_hash = args[:transaction]
#prev_tx = Bitcoin::P::Tx.from_json(open("http://test.webbtc.com/tx/#{prev_hash}.json"))
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
tx.add_out Bitcoin::Protocol::TxOut.new(value, pk)

# if all in and outputs are defined, start signing inputs.
a = "499602d2"
tx.in[0].script_sig = tx.in[0].script_sig = [ [ "04" , a].join ].pack("H*")

puts "json:\n"
puts tx.to_json # json
puts "\nhex:\n"
puts tx.to_payload.unpack("H*")[0] # hex binary

File.open(tx.hash + ".json", 'wb'){|f| f.print tx.to_json }
puts "use this json file for example with to push/send it to the network"
puts "ruby simple_network_monitor_and_util.rb send_tx=#{tx.hash}.json"

