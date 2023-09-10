<img align="right" width="500" height="300" top="100" src="./public/connexus.png">

# Smart Contract Documentation Connexus • [solidity](https://img.shields.io/badge/solidity-^0.8.17-lightgrey)

A **Connexus Project**, **Robust** Foundry Projects.

### Connexus comes from the connection between DREX and other blockchains. A new RWA (Real World Assets), Loan and OpenBanking tokenization experience implementing the tested and functional TBA (Token Bound Account) standard. 

**Building & Testing**

Build the foundry project with `forge build`. Then you can run tests with `forge test -vvvv`.

Deploy the foundry project with `forge script script/Deploy.s.sol:Deploy --rpc-url  https://testnet.bitfinity.network/ --private-key <private-key> --broadcast --verify -vvvv`. 

The entire project was aimed at implementing on ICP's Bitfinity EVM. Since network gas is much more accessible, the intention in our Roadmap is to implement ICPP LLM's A.I., where we will have access to the history of all users' TBAs and with on-chain artificial intelligence, offer the best investments according to the calculation of the user's score.

Implement Proxy UPSUpgradleable and TBA (ERC6551) - [ERC6551-Reference](https://github.com/erc6551/reference/tree/main)

**Addresses deployed on the Bitfinity and Sepolia Networks (In total 9 contracts with the test script and operating transactions in this document)**

Verified addresses in sepolia:

- ERC6551Registry: [ERC6551Registry](https://sepolia.etherscan.io/address/0xeeb84bdcb8286b2820c8db3a06d36513eb342d7a#writeContract)


- RWACar: [RWACard](https://sepolia.etherscan.io/address/0xde9bf698005a3baf2d253d87d18dda18136a8fe7#code)



- RWARealstate: [RWARealstate](https://sepolia.etherscan.io/address/0x1ff0fccd92c3b6a3aa1a1d382a12f117a1accdba#code)



- RealTokenizado: [RealTokenizado](https://sepolia.etherscan.io/address/0x2be060ddf220fe8735d0d1a297d89695dbebb9dc#code)



- CardTBA: [CardTBA](https://sepolia.etherscan.io/address/0xa449f502407bdce99fcab9a654198043d60942bd#code)



- BorrowAndStake: [BorrowAndStake](https://sepolia.etherscan.io/address/0x6a5944eb95272a37e48a11a6f71fea539f940dd1#code)


### Below are the main contracts

- ConnexusCard: [ConnexusCard](https://sepolia.etherscan.io/address/0x02cd5bced945ceec7571597a7a24a0bed799ea0c#code)



- Management: [Management](https://sepolia.etherscan.io/address/0xf536bbb1891f8d1ea3063c365d359648d90e234c#code)

### Main contract:

- ERC1967Proxy: [ERC1967Proxy](https://sepolia.etherscan.io/address/0xe53bc3a00ed4cb4500b4d3b3f5c0c1270ab65443#code)

### Bitfinity contracts:

-  Erc6551Registry: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
-  Utility Connexus: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
-  RealTokenizado: 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
-  RWAcar: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
-  RWARealstate: 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707
-  cardTBA: 0x0165878A594ca255338adfa4d48449f69242Eb8F
-  BorrowStake: 0xa513E6E4b8f2a923D98304ec87F64353C4D5C853
-  ConnexusCard: 0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6
-  Deploying: Management
-  Implementation: 0x8A791620dd6260079BF849Dc5567aDC3F2FdC318
-  Constructor args [1]: 0x8A791620dd6260079BF849Dc5567aDC3F2FdC318
-  Constructor args [2]: 0x1459457a0000000000000000000000002279b7a0a67db372996a5fab50d91eaa73d2ebe6000000000000000000000000dc64a140aa3e981100a9beca4e685f962f0cf6c90000000000000000000000005fc8d32690cc91d4c39d9d3abcbd16989f8757070000000000000000000000000165878a594ca255338adfa4d48449f69242eb8f000000000000000000000000e7f1725e7734ce288f8367e1bb143e90bb3f0512
-  Proxy Managment: 0x610178dA211FEF7D417bC0e6FeD39F05609AD788

### Polygon Mainnet contracts:

- Erc6551Registry: 0xED08BddcD7735440e4Ad5baa1E16D0ff83cF15d8
- Utility Connexus: 0x813f72E4f02ceF4a989B4FcAF3aF376C197e4D17
- RealTokenizado: 0x5691d2f186BF83d775906626d1F81c94dB40c68E
- RWAcar: 0xb0893FbB79099E7c68bE69D44Fb88920b00BEB6C
- RWARealstate: 0x865a68C132C24b3367423C79155053869912E43B
- cardTBA: 0x9E2406c7C8C2955bcB9b59581381d8e72DE711a4
- BorrowStake: 0xbe91F3d2058B0B20895C46E1b9F0C3AFD65de278
- ConnexusCard: 0x7483d598681a629049BB16D8b1088DBE569035Bc
- Deploying: Management
- Implementation: 0xdaA0de8f3032349311f1644EDf7528Fe0700979D
 Constructor args [1]: 0xdaA0de8f3032349311f1644EDf7528Fe0700979D
 Constructor args [2]: 0x1459457a0000000000000000000000007483d598681a629049bb16d8b1088dbe569035bc000000000000000000000000b0893fbb79099e7c68be69d44fb88920b00beb6c000000000000000000000000865a68c132c24b3367423c79155053869912e43b0000000000000000000000009e2406c7c8c2955bcb9b59581381d8e72de711a4000000000000000000000000ed08bddcd7735440e4ad5baa1e16d0ff83cf15d8
- Proxy Managment: 0x32842323061D7D9E01c0db6Db68Da25f0c6bdd1d

### Hyperledger Besu and Firefly contracts:

- Video: [Hyperledger-Firefly](https://youtu.be/HUUinUxpLhI)

- API:[Hyperledger-Connexus-API](https://b898-2804-431-cfef-b4b0-5c97-1b98-a113-6321.ngrok-free.app/api/v1/namespaces/default/apis/ConnexusManagement/api)

### all tx interactions and operations in Sepolia:

- create TBA Connexus: [Transaction](https://sepolia.etherscan.io/tx/0x58ab801e75b645698a75c3bacc430aa3e835e169a949ed9ac759b7d5a3e4a66f)

- tokenize car: [Transaction](https://sepolia.etherscan.io/tx/0x0d7688d8fc39d164842f2db07871c94dcb7517bf357ed9850ba1e49c2fed67f4)

- token car approval for borrowing: [Transaction](https://sepolia.etherscan.io/tx/0x16ec4c76b77a5d77914a9c0c971af3082351a13c855223e33026547ce9e07a5a)

- staking car on loan: [Transaction](https://sepolia.etherscan.io/tx/0x344e11128fe77a23a7f9d218b99b6f12298d583a2fc1e86aa84b4e18364e68ad)

- mint tokenized real for borrowing: [Transaction](https://sepolia.etherscan.io/tx/0x8292c30114d93f8f20fb2573393a324d63ab95663f415b014b82595d08db9948)

- taking out a loan/borrow: [Transaction](https://sepolia.etherscan.io/tx/0x42eddc2f6d07ccbd52fa502c4f23f6ab55db99868e1c6720ef5d1e9b1c1fb25d)


Inside the [`utils/`](./utils/) directory are a few preconfigured scripts that can be used to deploy and verify contracts.

Scripts take inputs from the cli, using silent mode to hide any sensitive information.

_NOTE: These scripts are required to be _executable_ meaning they must be made executable by running `chmod +x ./utils/*`._

_NOTE: these scripts will prompt you for the contract name and deployed addresses (when verifying). Also, they use the `-i` flag on `forge` to ask for your private key for deployment. This uses silent mode which keeps your private key from being printed to the console (and visible in logs)._


### I'm new, how do I get started?

We created a guide to get you started with: [GETTING_STARTED.md](./GETTING_STARTED.md).


### Blueprint

```txt
lib
├─ forge-std — https://github.com/foundry-rs/forge-std
├─ solmate — https://github.com/transmissions11/solmate
scripts
├─ Deploy.s.sol — Example Contract Deployment Script
src
├─ Management — Contract that will make the main interactions and that will create TBAcards and tokenize RWAs
├─ BorrowAndStake — This allows the user to tokenize their asset and place it as collateral and take out a loan at low interest rates.
├─ RealTokenizado — Token based on which will be used by financial institutions and individuals. (Retail)
├─ ConnexusCard — Responsible for creating Connexus TBAs
├─ RWACar — Contract for the creation of car tokenization NFTs
├─ RWARealstate — Contract for the creation of Real State tokenization NFTs
├─ OpenBankingStorage — Future implementation with A.I and calculating balances and generating the score
test
└─ ManagmentTest.t — Contract Test Management 
└─ BorrowAndStakeTest.t — Contract Test BorrowAndStake
```


### Notable Mentions

- [femplate](https://github.com/refcell/femplate)
- [foundry](https://github.com/foundry-rs/foundry)
- [solmate](https://github.com/Rari-Capital/solmate)
- [forge-std](https://github.com/brockelmore/forge-std)
- [forge-template](https://github.com/foundry-rs/forge-template)
- [foundry-toolchain](https://github.com/foundry-rs/foundry-toolchain)


### Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._

See [LICENSE](./LICENSE) for more details.
