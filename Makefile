all    :; SOLC_FLAGS="--optimize --optimize-runs=1000000" dapp --use solc:0.6.7 build --extract
clean  :; dapp clean
test   :; ./test-drizzle.sh
deploy-mainnet :; SOLC_FLAGS="--optimize --optimize-runs=1000000" dapp --use solc:0.6.7 create Drizzle 0x8b4ce5DCbb01e0e1f0521cd8dCfb31B308E52c24 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7 0x19c0976f590D67707E62397C87829d896Dc0f1F1
deploy-kovan :; SOLC_FLAGS="--optimize --optimize-runs=1000000" dapp --use solc:0.6.7 create Drizzle 0xedE45A0522CA19e979e217064629778d6Cc2d9Ea 0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb 0xcbB7718c9F39d05aEEDE1c472ca8Bf804b2f1EaD
