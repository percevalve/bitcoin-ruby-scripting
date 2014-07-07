require "./learningtx"
# p Bitcoin.generate_address # returns address, privkey, pubkey, hash160

prev_hash = "6f8db4b7c2d47400c8274c36561eb9306d258e3907d38c185bcc5a132bcd9e87"
p donnees = "http://test.webbtc.com/tx/#{prev_hash}.json"
prev_tx = Bitcoin::P::Tx.from_json(open(donnees))
prev_tx_output_index = 0
value = prev_tx.outputs[prev_tx_output_index].value


kk = Bitcoin.open_key(Gaston.clef_2.private) # <- privkey
#to send to address
hash160 = Bitcoin.hash160_from_address(Gaston.clef_1.address)
send_to_clef_1 =  [ "41", kk.public_key_hex,        "ac"]
# the equivalent ruby method
# tx.add_out Bitcoin::Protocol::TxOut.value_to_address(value, "mn9CMv6V2h2Rj6DUWe9swF5ANkBedKNDNZ") # 

#hqs the previous is OP_TRUE, this is not actually necessary
a = "3049464648454c4c638cca1da4b21f11319e19106b4dd24b39a50d38adf4523cc5ae360b1360751c4287985bb700ca739e4abc855c7c14724704399ded7cd1c359a2609bd7ea472f"

b = "04d4ff2a6ca21e30a142f9059d6eea0dd1aab34a25f8570e901a6a15a1b5a8a229b4092bbcbca7d3f955f2f5b6f369526322b7bff4fab135249933b4fbe5b864be"
a = "499602d2"
aa = "499602d3"
push_a_to_stack = [ "04" , a, "04" , aa, "75", :sig,"01" ]

tx = make_my_simple_transaction prev_hash, prev_tx_output_index, value, push_a_to_stack, send_to_clef_1, prev_tx, kk

# finish check
tx = Bitcoin::Protocol::Tx.new( tx.to_payload )
p tx.hash
p tx.verify_input_signature(0, prev_tx) == true

print_tx_to_send tx