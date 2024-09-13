#!/bin/sh



wget -O loader.sh https://raw.githubusercontent.com/DiscoverMyself/Ramanode-Guides/main/loader.sh && chmod +x loader.sh && ./loader.sh

sleep 4



sudo apt-get update && sudo apt get upgrade -y

clear



echo "Installing Hardhat and dotenv..."

npm install --save-dev hardhat

npm install dotenv

npm install @swisstronik/utils

echo "Installation completed."



echo "Creating a Hardhat project..."

npx hardhat



rm -f contracts/Lock.sol

echo "Lock.sol removed."



echo "Hardhat project created."



echo "Installing Hardhat toolbox..."

npm install --save-dev @nomicfoundation/hardhat-toolbox

echo "Hardhat toolbox installed."



echo "Creating .env file..."

read -p "Enter your private key: " PRIVATE_KEY

echo "PRIVATE_KEY=$PRIVATE_KEY" > .env

echo ".env file created."



echo "Configuring Hardhat..."

cat <<EOL > hardhat.config.js

require("@nomicfoundation/hardhat-toolbox");

require("dotenv").config();



module.exports = {

  solidity: "0.8.19",

  networks: {

    swisstronik: {

      url: "https://json-rpc.testnet.swisstronik.com/",

      accounts: [\`0x\${process.env.PRIVATE_KEY}\`],

    },

  },

};

EOL

echo "Hardhat configuration completed."



echo "Creating Hello_swtr.sol contract..."

mkdir -p contracts

cat <<EOL > contracts/Hello_swtr.sol

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;



contract Swisstronik {

    string private message;



    constructor(string memory _message) payable {

        message = _message;

    }



    function setMessage(string memory _message) public {

        message = _message;

    }



    function getMessage() public view returns(string memory) {

        return message;

    }

}

EOL

echo "Hello_swtr.sol contract created."



echo "Compiling the contract..."

npx hardhat compile

echo "Contract compiled."



echo "Creating deploy.js script..."

mkdir -p scripts

cat <<EOL > scripts/deploy.js

const hre = require("hardhat");



async function main() {

  const contract = await hre.ethers.deployContract("Swisstronik", ["He
