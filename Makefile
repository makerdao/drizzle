all    :;  DAPP_BUILD_OPTIMIZE=1 DAPP_BUILD_OPTIMIZE_RUNS=1000000 dapp --use solc:0.6.12 build --extract
clean  :; dapp clean
test   :; ./test-drizzle.sh
deploy-mainnet :; make && dapp --use solc:0.6.12 create Drizzle
deploy-kovan :; make && dapp --use solc:0.6.12 create Drizzle
