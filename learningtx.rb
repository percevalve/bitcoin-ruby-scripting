#Those were written to work with testnet for training purposed, do not use for real money
require 'bitcoin'
require 'open-uri'
require 'gaston'
require 'pp'

Bitcoin.network = :testnet3

Gaston.configure do |gaston|
  gaston.files = Dir[".config/gaston.yml"]
end

def make_my_simple_transaction prev_hash, prev_tx_output_index, value, hash_in, hash_out, prev_tx="", kk=""
  tx = Bitcoin::Protocol::Tx.new
  binary = [prev_hash].pack("H*").reverse
  #set reference for previous transactions
  tx.add_in Bitcoin::Protocol::TxIn.new(binary, prev_tx_output_index)
  #write the "out script" first to ensure you can sign the "In" script if required
  pk =  [ hash_out.join ].pack("H*")
  tx.add_out Bitcoin::Protocol::TxOut.new(value, pk)
  if hash_in.include?(:sig)
  	sig_position = hash_in.find_index(:sig)
  	sig = Bitcoin.sign_data(kk, tx.signature_hash_for_input(0, prev_tx)) 
  	hash_in[sig_position] = [[sig.bytesize+1].pack("C"), sig].join.unpack("H*")
    sig = Bitcoin.sign_data(kk, tx.signature_hash_for_input(0, prev_tx))
    #tx.in[0].script_sig = Bitcoin::Script.to_signature_pubkey_script(sig, [kk.public_key_hex].pack("H*"))  
  end
  tx.in[0].script_sig = [ hash_in.join ].pack("H*")
  
  
  return tx
end

def get_args_for_transaction my_argv
  {   
    transaction:  my_argv.find{|a| a[/transac=(.+)/, 1] } && $1,
    output_index: my_argv.find{|a| a[/index=(.+)/, 1] } && $1,
    value: my_argv.find{|a| a[/v=(.+)/, 1] } && $1,
    script: my_argv.find{|a| a[/script_pub_key=(.+)/, 1] } && $1,
  }
end

def generate_complete_set 
  address_indexing_for_bitcoin_generate_address = [:address, :privkey, :pubkey, :hash160]
  package_complete_set Bitcoin.generate_address, address_indexing_for_bitcoin_generate_address
end

def package_complete_set key, address_indexing
  # p Bitcoin.generate_address # returns address, privkey, pubkey, hash160
  address = key[address_indexing.find_index :address]
  #not sure this is usefull at all, just doing it...
  if !Bitcoin::valid_address?(address)
    puts "There was an error generating the address"
    return false
  end
  the_object = {}
  address_indexing.each_with_index do |reference,index|
    the_object[reference] = key[index]
  end
  return the_object
end

def print_tx_to_send my_tx
	puts "json:\n"
	puts my_tx.to_json # json
	puts "\nhex:\n"
	puts my_tx.to_payload.unpack("H*")[0] # hex binary
	File.open(my_tx.hash + ".json", 'wb'){|f| f.print my_tx.to_json }
	puts "use this json file for example with to push/send it to the network"
	puts "ruby simple_network_monitor_and_util.rb send_tx=#{my_tx.hash}.json -n=testnet3"
	puts "you can also push it using http://test.webbtc.com/relay_tx"
end

