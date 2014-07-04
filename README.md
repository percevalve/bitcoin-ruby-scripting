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


#Testing some custom scripts
Just use partial_to_clef_2_rest_in_special.rb to create a script with 3 output :
* index 0 : send money to clef_2
* index 1 : script with OP_EQUAL
* index 2 : script with OP_TRUE

You can after that use the scripts get_OP_TRUE and OP_EQUAL to transfert back the "test" bitcoin to clef_1

#Sending money between clef_1 and clef_2
The script standard_from_clef_1_clef_2.rb is an example of standard script to send money between both account.