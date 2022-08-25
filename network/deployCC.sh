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

# Chaincode config variable

# CHANNEL_NAME="mychannel"
CC_NAME="epeople"
CC_SRC_PATH="../contract"
CC_RUNTIME_LANGUAGE="golang"
CC_VERSION="1"
CHANNEL_NAME="mychannel"


## package the chaincode
infoln "Packaging chaincode"
set -x
peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

## Install chaincode on peer0.org1
infoln "Installing chaincode on peer0.org1..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


## Install chaincode on peer0.org2
infoln "Installing chaincode on peer0.org2..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


## Install chaincode on peer0.uni1
infoln "Installing chaincode on peer0.uni1..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Uni1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/uni1.example.com/peers/peer0.uni1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uni1.example.com/users/Admin@uni1.example.com/msp
export CORE_PEER_ADDRESS=localhost:11051

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


## Install chaincode on peer0.uni2
infoln "Installing chaincode on peer0.uni2..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Uni2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/uni2.example.com/peers/peer0.uni2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uni2.example.com/users/Admin@uni2.example.com/msp
export CORE_PEER_ADDRESS=localhost:13051

set -x
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

set -x
peer lifecycle chaincode queryinstalled >&log.txt  
{ set +x; } 2>/dev/null
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)



## approve the definition for org1
infoln "approve the definition on peer0.org1..."

ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

set -x
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence 1 >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


## approve the definition for org2
infoln "approve the definition on peer0.org2..."

ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

set -x
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence 1 >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


## approve the definition for uni1
infoln "approve the definition on peer0.uni1..."

ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Uni1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/uni1.example.com/peers/peer0.uni1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uni1.example.com/users/Admin@uni1.example.com/msp
export CORE_PEER_ADDRESS=localhost:11051

set -x
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence 1 >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


## approve the definition for uni2
infoln "approve the definition on peer0.uni2..."

ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Uni2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/uni2.example.com/peers/peer0.uni2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/uni2.example.com/users/Admin@uni2.example.com/msp
export CORE_PEER_ADDRESS=localhost:13051

set -x
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence 1 >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


## check commitreadiness
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence 1 --tls --cafile $ORDERER_CA --output json


## commit the chaincode definition
infoln "commit the chaincode definition"

PEER_CONN_PARMS="--peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --peerAddresses localhost:11051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/uni1.example.com/peers/peer0.uni1.example.com/tls/ca.crt --peerAddresses localhost:13051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/uni2.example.com/peers/peer0.uni2.example.com/tls/ca.crt"

set -x
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} $PEER_CONN_PARMS --version ${CC_VERSION} --sequence 1 >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME} --cafile $ORDERER_CA


## TEST1 : Invoking the chaincode
infoln "TEST1 : Invoking the chaincode"
set -x
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS -c '{"function":"AddComplaintRequest","Args":["REQ:1", "ohth", "taehyun", "01012345678","Gyunggido", true, "title", "content", "location", "20220825"]}' >&log.txt
{ set +x; } 2>/dev/null
cat log.txt
sleep 3

## TEST2 : Invoking the chaincode
infoln "TEST2 : Invoking the chaincode"
set -x
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS -c '{"function":"UpdateComplaintRequestStatus","Args":["REQ:1", 1, "20220825"]}' >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

## TEST3 : Invoking the chaincode
infoln "TEST3 : Invoking the chaincode"
set -x
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS -c '{"function":"AddComplaintResult","Args":["REQ:1", "RES:1", "education center", "twice", "zzwii", "20220901", "resultcontent"]}' >&log.txt
{ set +x; } 2>/dev/null
cat log.txt


## TEST4 : query the chaincode
infoln "TEST4 : query the chaincode"
set -x
peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["ListComplaintRequestAll"]}' >&log.txt
{ set +x; } 2>/dev/null
cat log.txt

