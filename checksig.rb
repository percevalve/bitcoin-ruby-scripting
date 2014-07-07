require './learningtx'

#-transac=aa31ca135ba0e9b9175037b72e2eaa19efec8e6881bd0636af82f7b88ca3bf74 -index=0

args = get_args_for_transaction ARGV 
prev_hash = args[:transaction]
prev_tx_output_index = args[:output_index].to_i

prev_tx = Bitcoin::P::Tx.from_json(open("http://test.webbtc.com/tx/#{prev_hash}.json"))
value = prev_tx.outputs[prev_tx_output_index].value

#to send to address
hash160 = Bitcoin.hash160_from_address(Gaston.clef_1.address)
send_to_clef_2 =  ["ac"]
# the equivalent ruby method
# tx.add_out Bitcoin::Protocol::TxOut.value_to_address(value, "mn9CMv6V2h2Rj6DUWe9swF5ANkBedKNDNZ") # 

#has the previous is OP_TRUE, this is not actually necessary
kk = Bitcoin.open_key(Gaston.clef_2.private) # <- privkey
puts kk.public_key_hex
#Always add a 01 after the signature, the left to push will be included when the signature is generated.
push_sign_stack = [:sig,"01" ,"41", kk.public_key_hex]

tx = make_my_simple_transaction prev_hash, prev_tx_output_index, value, push_sign_stack, send_to_clef_2, prev_tx, kk

print_tx_to_send tx