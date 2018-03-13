
docker kill $(docker ps -q)
docker rm $(docker ps -qa)
docker network prune
echo "y"

echo "**************************** Docker containers killed and removed ****************************"

rm -R channel-artifacts
rm -R crypto-config

echo "**************************** Old Certificates removed ****************************"

mkdir channel-artifacts
mkdir crypto-config

cryptogen generate --config crypto-config.yaml

echo "**************************** New Certificates Generated ****************************"

export FABRIC_CFG_PATH=$PWD
export IMAGE_TAG=latest
export COMPOSE_PROJECT_NAME=first_project

configtxgen -profile DebutAxisGenesisBlockProfile -outputBlock ./channel-artifacts/genesis.block

export CHANNEL_NAME=channel1  && configtxgen -profile DebutAxisChannelProfile -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

configtxgen -profile DebutAxisChannelProfile -outputAnchorPeersUpdate ./channel-artifacts/DebutMSPanchors.tx -channelID $CHANNEL_NAME -asOrg DebutInfotechPvtLtd
configtxgen -profile DebutAxisChannelProfile -outputAnchorPeersUpdate ./channel-artifacts/AxisMSPanchors.tx -channelID $CHANNEL_NAME -asOrg AxisBankPvtLtd
docker-compose -f docker-compose-cli.yaml up