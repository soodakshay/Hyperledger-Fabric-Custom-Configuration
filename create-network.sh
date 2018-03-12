cryptogen generate --config crypto-config.yaml
configtxgen -profile Debut_Axis_Orderer_Genesis_Block -outputBlock ./channel-artifacts/genesis.block 
export CHANNEL_NAME=channel1  && ../bin/configtxgen -profile Debut_Axis_Channel_Profile -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
configtxgen -profile Debut_Axis_Channel_Profile -outputAnchorPeersUpdate ./channel-artifacts/DebutMSPanchors.tx -channelID $CHANNEL_NAME -asOrg Debut_Infotech_Pvt_Ltd
configtxgen -profile Debut_Axis_Channel_Profile -outputAnchorPeersUpdate ./channel-artifacts/AxisMSPanchors.tx -channelID $CHANNEL_NAME -asOrg Axis_Bank_Pvt_Ltd
export IMAGE_TAG=latest
docker-compose -f docker-compose-cli.yaml up





