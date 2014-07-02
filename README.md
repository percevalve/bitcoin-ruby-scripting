This is a small demo to generate custom script using bitcoin-ruby on testnet

# Creating addresses

Everything is in  ./config/gaston.yml
The script create_address.rb will do the job for you
`ruby create_address.rb`
The formatting is in the file, if you want to do it manually ./config/example.yml

#Get some money
Many "Faucet" are available for testnet, I have choosen :
https://tpfaucet.appspot.com
If you have MAC OS X, the script get_money.rb will open the page and put the address in the clipboard 
`ruby get_money.rb`
You will need to wait for the transaction to get included in the blockchain to see it on http://test.webbtc.com


#Sending it back to the faucet
The script sendback_to_faucet_from_regular_script.rb, will send the money directly back to the faucet using a standard script.
