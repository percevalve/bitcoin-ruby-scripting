require 'bitcoin'
require 'open-uri'
require 'gaston'

Bitcoin.network = :testnet3
satoshi = 10 ** 8

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
puts "http://test.webbtc.com/tx/#{prev_hash}.json"
prev_tx = Bitcoin::P::Tx.from_json(open("http://test.webbtc.com/tx/#{prev_hash}.json"))
prev_tx_output_index = args[:output_index].to_i
value = prev_tx.outputs[prev_tx_output_index].value

tx = Bitcoin::Protocol::Tx.new
tx.add_in Bitcoin::Protocol::TxIn.new(prev_tx.binary_hash, prev_tx_output_index, 0)

#to send to address
hash160 = Bitcoin.hash160_from_address(Gaston.clef_2.address)
pk =  [ ["76", "a9",    "14",   hash160,   "88",        "ac"].join ].pack("H*")
# the equivalent ruby method
# tx.add_out Bitcoin::Protocol::TxOut.value_to_address(value, "mn9CMv6V2h2Rj6DUWe9swF5ANkBedKNDNZ") # 
tx.add_out Bitcoin::Protocol::TxOut.new((value- 1 * satoshi) , pk)

pk =  [ [ "04",   "499602d2",   "87"].join ].pack("H*")
tx.add_out Bitcoin::Protocol::TxOut.new(0.1 * satoshi, pk)

pk =  [ ["75", "51"].join ].pack("H*")
tx.add_out Bitcoin::Protocol::TxOut.new(0.9 * satoshi, pk)



# if all in and outputs are defined, start signing inputs.
kk = Bitcoin.open_key(Gaston.clef_1.private) # <- privkey
sig = Bitcoin.sign_data(kk, tx.signature_hash_for_input(0, prev_tx))
tx.in[0].script_sig = Bitcoin::Script.to_signature_pubkey_script(sig, [kk.public_key_hex].pack("H*"))

# finish check
tx = Bitcoin::Protocol::Tx.new( tx.to_payload )
p tx.hash
p tx.verify_input_signature(0, prev_tx) == true

puts "json:\n"
puts tx.to_json # json
puts "\nhex:\n"
puts tx.to_payload.unpack("H*")[0] # hex binary

File.open(tx.hash + ".json", 'wb'){|f| f.print tx.to_json }
puts "use this json file for example with to push/send it to the network"
puts "ruby simple_network_monitor_and_util.rb send_tx=#{tx.hash}.json"

