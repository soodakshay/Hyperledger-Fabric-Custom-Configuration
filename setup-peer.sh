export CHANNEL_NAME=channel1

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