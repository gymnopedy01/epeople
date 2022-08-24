#!/bin/bash

C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_RESET='\033[0m'

# subinfoln echos in blue color
function infoln() {
  echo -e "${C_YELLOW}${1}${C_RESET}"
}

function subinfoln() {
  echo -e "${C_BLUE}${1}${C_RESET}"
}

# add PATH to ensure we are picking up the correct binaries
export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

CHANNEL_NAME="mychannel"


# create channel
infoln "Generating channel create transaction '${CHANNEL_NAME}.tx'"
set -x
configtxgen -profile TwoOrgsTwoUnisChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
{ set +x; } 2>/dev/null

export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
set -x
peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.example.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


# join channel (peer0.org1.com)
infoln "Joining org1 peer to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer0.org2.com)
infoln "Joining org2 peer to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer0.uni1.com)
infoln "Joining uni1 peer to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Uni1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/uni1.example.com/peers/peer0.uni1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uni1.example.com/users/Admin@uni1.example.com/msp
export CORE_PEER_ADDRESS=localhost:11051

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

# join channel (peer0.uni2.com)
infoln "Joining uni2 peer to the channel..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Uni2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/uni2.example.com/peers/peer0.uni2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uni2.example.com/users/Admin@uni2.example.com/msp
export CORE_PEER_ADDRESS=localhost:13051

set -x
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
{ set +x; } 2>/dev/null
cat log.txt