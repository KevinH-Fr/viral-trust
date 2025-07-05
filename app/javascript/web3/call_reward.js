// app/javascript/web3/call_reward.js
const { ethers } = require("ethers");

const recipient = process.argv[2];
const amount = process.argv[3];
const privateKey = process.argv[4];

if (!recipient || !amount || !privateKey) {
  console.error("Usage: node call_reward.js <recipient> <amount> <privateKey>");
  process.exit(1);
}

const CONTRACT_ADDRESS = "0x2De93D4B9c39CC2AAd10CCe26D8e2e9d06aa1A4b";
const CONTRACT_ABI = [
  {
    "inputs": [
      { "internalType": "address", "name": "recipient", "type": "address" },
      { "internalType": "uint256", "name": "amount", "type": "uint256" }
    ],
    "name": "reward",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];

const RPC_URL = "https://testnet.evm.nodes.onflow.org";

async function main() {
  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const wallet = new ethers.Wallet(privateKey, provider);
  const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, wallet);

  try {
    const tx = await contract.reward(recipient, amount);
    console.log("✅ Transaction hash:", tx.hash);
  } catch (error) {
    console.error("❌ Error:", error);
    process.exit(1);
  }
}

main();
