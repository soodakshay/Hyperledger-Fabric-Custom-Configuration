#!/bin/bash


docker kill $(docker ps -q)
docker rm $(docker ps -qa)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q)
docker network prune

rm -R channel-artifacts
rm -R crypto-config

echo "**************************** Old Certificates removed ****************************"

mkdir channel-artifacts

cryptogen generate --config crypto-config.yaml

export root_dir=$PWD

cd $root_dir

cd ./crypto-config/peerOrganizations/debut.com/ca/

export DEBUT_CA_KEY=$(ls *_sk)

echo $DEBUT_CA_KEY

cd $root_dir

cd ./crypto-config/peerOrganizations/axisbank.com/ca/

export AXIS_CA_KEY=$(ls *_sk)

echo $AXIS_CA_KEY

cd $root_dir

echo "**************************** New Certificates Generated ****************************"

export FABRIC_CFG_PATH=$PWD
export IMAGE_TAG=latest
export COMPOSE_PROJECT_NAME=s

configtxgen -profile DebutAxisGenesisBlockProfile -outputBlock ./channel-artifacts/genesis.block

export CHANNEL_NAME=channel1  && configtxgen -profile DebutAxisChannelProfile -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

configtxgen -profile DebutAxisChannelProfile -outputAnchorPeersUpdate ./channel-artifacts/DebutMSPanchors.tx -channelID $CHANNEL_NAME -asOrg DebutInfotechPvtLtd
configtxgen -profile DebutAxisChannelProfile -outputAnchorPeersUpdate ./channel-artifacts/AxisMSPanchors.tx -channelID $CHANNEL_NAME -asOrg AxisBankPvtLtd
docker-compose -f docker-compose-cli.yaml up