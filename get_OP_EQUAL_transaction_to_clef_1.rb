require './learningtx'

#ruby get_OP_EQUAL_transaction_to_clef_1.rb -transac=19f1f9aa9bbf867ed29b1dcb7bb91118c1e84fdf1fd0aec2db313bc9392303b0 -index=1 -v=0.1

args = get_args_for_transaction ARGV 
prev_hash = args[:transaction]
prev_tx_output_index = args[:output_index].to_i

#In this case getting the info is just to have the value... we can do it manually
if args[:value].nil?
  prev_tx = Bitcoin::P::Tx.from_json(open("http://test.webbtc.com/tx/#{prev_hash}.json"))
  value = prev_tx.outputs[prev_tx_output_index].value
else
  value = args[:value].to_f
end

#to send to address
hash160 = Bitcoin.hash160_from_address(Gaston.clef_1.address)
send_to_clef_1 =  ["76", "a9",    "14",   hash160,   "88",        "ac"]
# the equivalent ruby method
# tx.add_out Bitcoin::Protocol::TxOut.value_to_address(value, "mn9CMv6V2h2Rj6DUWe9swF5ANkBedKNDNZ") # 

#hqs the previous is OP_TRUE, this is not actually necessary
a = "499602d2"
push_a_to_stack = [ "04" , a]

tx = make_my_simple_transaction prev_hash, prev_tx_output_index, value, push_a_to_stack, send_to_clef_1

print_tx_to_send tx