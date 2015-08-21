#deletes the current bitcoind and bitcoin-cli binray files
#downloads XT 0.11a binaries and installs them
echo "removing bitcoin core and intsalling XT ... starts in 10 sec"
sleep 10s
#get XT binary files fron bitseed.org
wget https://www.bitseed.org/device/bitcoin-xt-0.11a/bitcoin-xt-0.11a.zip

#stop bitcoin
bitcoin-cli stop

#remove ild bitcoin binaries
rm /home/linaro/bitcoind
rm /home/linaro/bitcoin-cli

#install the XT binary files in /home/linaro
unzip bitcoin-xt-0.11a.zip
cp bitcoin-xt-0.11a/bitcoin*  /home/linaro

#restart bitcoind
echo "XT installed, bitcoin will now restart.  Allow about 10 minutes before it is active"
bitcoind -daemon