#!/bin/bash

CHANNEL_NAME=channel1

echo "******************SET CHANNEL_NAME=channel1******************"

peer channel create -o hr.debut.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/debut.com/orderers/hr.debut.com/msp/tlscacerts/tlsca.debut.com-cert.pem

echo "******************CHANNEL CREATED******************"

peer channel join -b channel1.block

echo "******************Peer 0 Of Debut Joined Channel1******************"

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/axisbank.com/users/Admin@axisbank.com/msp CORE_PEER_ADDRESS=peer0.axisbank.com:7051 CORE_PEER_LOCALMSPID=AxisMSP CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/axisbank.com/peers/peer0.axisbank.com/tls/ca.crt peer channel join -b channel1.block

echo "******************Peer 0 Of Axis Joined Channel1******************"

# peer channel update -o hr.debut.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/DebutMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/debut.com/orderers/hr.debut.com/msp/tlscacerts/tlsca.debut.com-cert.pem

echo "******************DEBUT MSP ANCHOR PEER CHANNEL UPDATED******************"

# CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/axisbank.com/users/Admin@axisbank.com/msp CORE_PEER_ADDRESS=peer0.axisbank.com:7051 CORE_PEER_LOCALMSPID=AxisMSP CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/axisbank.com/peers/peer0.axisbank.com/tls/ca.crt peer channel update -o hr.debut.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/AxisMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/debut.com/orderers/hr.debut.com/msp/tlscacerts/tlsca.debut.com-cert.pem

echo "******************AXIS MSP ANCHOR PEER CHANNEL UPDATED******************"


 peer chaincode install -n cc -v 1.0 -p github.com/chaincode/

 echo "******************CHAINCODE cc 1.0 INSTALLED******************"

 peer chaincode instantiate -o hr.debut.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/debut.com/orderers/hr.debut.com/msp/tlscacerts/tlsca.debut.com-cert.pem -C $CHANNEL_NAME -n cc -v 1.0 -c '{"Args":[]}'  -P "OR ('DebutMSP.peer','AxisMSP.peer')"

echo "******************CHAINCODE cc 1.0 INSTANTIATED******************"

peer chaincode invoke -o hr.debut.com:7050  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/debut.com/orderers/hr.debut.com/msp/tlscacerts/tlsca.debut.com-cert.pem  -C $CHANNEL_NAME -n mychaincode -c '{"Function":"addUser","Args":["1","Akshay","Sood"]}'

# sleep 5

# peer chaincode invoke -o hr.debut.com:7050  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/debut.com/orderers/hr.debut.com/msp/tlscacerts/tlsca.debut.com-cert.pem  -C $CHANNEL_NAME -n cc -c '{"Args":["initLedger"]}'

# sleep 5

# peer chaincode invoke -o hr.debut.com:7050  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/debut.com/orderers/hr.debut.com/msp/tlscacerts/tlsca.debut.com-cert.pem  -C $CHANNEL_NAME -n cc -c '{"Args":["queryAllCars"]}'

# sleep 2

# sudo apt-get update

# sleep 10

# sudo apt-get install curl