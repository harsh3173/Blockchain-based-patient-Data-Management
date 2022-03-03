#!/bin/bash

source scriptUtils.sh

function createHosp1() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/hosp1.coep.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/hosp1.coep.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://hosp1admin:hosp1coep@localhost:7054 --caname ca-hosp1 --tls.certfiles ${PWD}/organizations/fabric-ca/hosp1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hosp1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hosp1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hosp1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hosp1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/hosp1.coep.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-hosp1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/hosp1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-hosp1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/hosp1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-hosp1 --id.name hosp1hosp1admin --id.secret hosp1hosp1coep --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/hosp1/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/hosp1.coep.com/peers
  mkdir -p organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-hosp1 -M ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/msp --csr.hosts peer0.hosp1.coep.com --tls.certfiles ${PWD}/organizations/fabric-ca/hosp1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hosp1.coep.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-hosp1 -M ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/tls --enrollment.profile tls --csr.hosts peer0.hosp1.coep.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/hosp1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/hosp1.coep.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hosp1.coep.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/hosp1.coep.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hosp1.coep.com/tlsca/tlsca.hosp1.coep.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/hosp1.coep.com/ca
  cp ${PWD}/organizations/peerOrganizations/hosp1.coep.com/peers/peer0.hosp1.coep.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/hosp1.coep.com/ca/ca.hosp1.coep.com-cert.pem

  mkdir -p organizations/peerOrganizations/hosp1.coep.com/users
  mkdir -p organizations/peerOrganizations/hosp1.coep.com/users/User1@hosp1.coep.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-hosp1 -M ${PWD}/organizations/peerOrganizations/hosp1.coep.com/users/User1@hosp1.coep.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hosp1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hosp1.coep.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hosp1.coep.com/users/User1@hosp1.coep.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/hosp1.coep.com/users/Admin@hosp1.coep.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://hosp1hosp1admin:hosp1hosp1coep@localhost:7054 --caname ca-hosp1 -M ${PWD}/organizations/peerOrganizations/hosp1.coep.com/users/Admin@hosp1.coep.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hosp1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hosp1.coep.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hosp1.coep.com/users/Admin@hosp1.coep.com/msp/config.yaml

}

function createHosp2() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/hosp2.coep.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/hosp2.coep.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://hosp2admin:hosp2coep@localhost:8054 --caname ca-hosp2 --tls.certfiles ${PWD}/organizations/fabric-ca/hosp2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-hosp2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-hosp2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-hosp2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-hosp2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/hosp2.coep.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-hosp2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/hosp2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-hosp2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/hosp2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-hosp2 --id.name hosp2hosp2admin --id.secret hosp2hosp2coep --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/hosp2/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/hosp2.coep.com/peers
  mkdir -p organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-hosp2 -M ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/msp --csr.hosts peer0.hosp2.coep.com --tls.certfiles ${PWD}/organizations/fabric-ca/hosp2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hosp2.coep.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-hosp2 -M ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/tls --enrollment.profile tls --csr.hosts peer0.hosp2.coep.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/hosp2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/hosp2.coep.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hosp2.coep.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/hosp2.coep.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/hosp2.coep.com/tlsca/tlsca.hosp2.coep.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/hosp2.coep.com/ca
  cp ${PWD}/organizations/peerOrganizations/hosp2.coep.com/peers/peer0.hosp2.coep.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/hosp2.coep.com/ca/ca.hosp2.coep.com-cert.pem

  mkdir -p organizations/peerOrganizations/hosp2.coep.com/users
  mkdir -p organizations/peerOrganizations/hosp2.coep.com/users/User1@hosp2.coep.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-hosp2 -M ${PWD}/organizations/peerOrganizations/hosp2.coep.com/users/User1@hosp2.coep.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hosp2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hosp2.coep.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hosp2.coep.com/users/User1@hosp2.coep.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/hosp2.coep.com/users/Admin@hosp2.coep.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://hosp2hosp2admin:hosp2hosp2coep@localhost:8054 --caname ca-hosp2 -M ${PWD}/organizations/peerOrganizations/hosp2.coep.com/users/Admin@hosp2.coep.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/hosp2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/hosp2.coep.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/hosp2.coep.com/users/Admin@hosp2.coep.com/msp/config.yaml

}

function createOrderer() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/ordererOrganizations/coep.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/coep.com
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/coep.com/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/ordererOrganizations/coep.com/orderers
  mkdir -p organizations/ordererOrganizations/coep.com/orderers/coep.com

  mkdir -p organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/msp --csr.hosts orderer.coep.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coep.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/tls --enrollment.profile tls --csr.hosts orderer.coep.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/msp/tlscacerts/tlsca.coep.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/coep.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coep.com/orderers/orderer.coep.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coep.com/msp/tlscacerts/tlsca.coep.com-cert.pem

  mkdir -p organizations/ordererOrganizations/coep.com/users
  mkdir -p organizations/ordererOrganizations/coep.com/users/Admin@coep.com

  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coep.com/users/Admin@coep.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coep.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/coep.com/users/Admin@coep.com/msp/config.yaml

}
