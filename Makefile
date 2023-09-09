# && lcov --remove lcov.info '/test/fuzz/*' -o lcov.info 
# && python ./clean_coverage_report.py
# forge coverage --mp "test/unit/*" --report lcov && genhtml lcov.info --branch-coverage --output-dir coverage
# forge verify-contract $(address) $(contract) --chain-id $(chain_id) --watch --constructor-args $(CONSTRUCTOR_ARGS) --etherscan-api-key $(ETHERSCAN_API_KEY)
# ifneq ($(constructor_signature),)
# 	VERIFY_COMMAND := $(contract_address) $(contract) --chain-id $(chain_id) --watch --constructor-args $(shell cast abi-encode $(constructor_signature) $(input_parameters))
# else
# 	VERIFY_COMMAND := $(contract_address) $(contract) --chain-id $(chain_id) --watch
# endif
# forge verify-contract $(VERIFY_COMMAND)
# if [ -n "$(constructor_signature)" ]; then \
# 	constructor_args_encoded=$$(cast abi-encode $(constructor_signature) $(input_parameters)); \
# 	verify_command="forge verify-contract $(contract_address) $(contract) --chain-id $(chain_id) --watch --constructor-args $$constructor_args_encoded"; \
# else \
# 	verify_command="forge verify-contract $(contract_address) $(contract) --chain-id $(chain_id) --watch"; \
# fi; \
# \
# $$verify_command

# CONSTRUCTOR_COMMAND := $(shell cast abi-encode $(constructor_signature) $(input_parameters))
# 	VERIFY_COMMAND := $(contract_address) $(contract) --chain-id $(chain_id) --watch --constructor-args $(CONSTRUCTOR_COMMAND)


-include .env

ifeq ($(network),sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --broadcast --verify -vvvv
endif

ifeq ($(network),goerli)
	NETWORK_ARGS := --rpc-url $(GOERLI_RPC_URL) --broadcast --verify -vvvv
endif

ifeq ($(network),mumbai)
	NETWORK_ARGS := --rpc-url $(MUMBAI_RPC_URL) --broadcast --verify -vvvv
endif

ifeq ($(network),mainnet)
	NETWORK_ARGS := --rpc-url $(MAINNET_RPC_URL) --broadcast --verify -vvvv
endif

ifeq ($(network),lachain)
	NETWORK_ARGS := --rpc-url $(LACHAIN_RPC_URL) --broadcast --verify -vvvv
endif

ifeq ($(network),bit)
	NETWORK_ARGS := --rpc-url $(BITFINITY_RPC_URL) --broadcast --verify -vvvv
endif

ifneq ($(constructor_signature),)	
	CONSTRUCTOR_COMMAND := $(shell cast abi-encode "$(constructor_signature)" $(input_parameters))
	VERIFY_COMMAND := $(contract_address) $(contract) --chain-id $(chain_id) --watch --constructor-args $(CONSTRUCTOR_COMMAND)
else
	VERIFY_COMMAND := $(contract_address) $(contract) --chain-id $(chain_id) --watch
endif

run_test:;
	forge test --fork-url $(SEPOLIA_RPC_URL) -vvvv

run_coverage:;
	forge coverage --mp "test/unit/*" --report lcov

coverage_report:;
	genhtml lcov.info --branch-coverage --output-dir coverage

deploy:;
	forge script script/Deploy.s.sol $(NETWORK_ARGS)

deploy_mocks:;
	forge script script/DeployMocks.s.sol $(NETWORK_ARGS)

verify:;	
	forge verify-contract $(VERIFY_COMMAND)
