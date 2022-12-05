#!/bin/bash

#
# This code is property of Wayaga LLC
# You shouldn't use it without authorization of Wayaga LLC
# To use it please contact rodolfo.kohn@wayaga.com for authorization
#


# $1 is the pod that we want to monitor

POD_NAME=
NAMESPACE=default
INTERFACE=eth0
BASENAME=dlltagent
OUTPUT_FILE=${BASENAME}_searchpod.yaml

help () {
  echo
  echo "monitorPod.sh will set up a yaml file dlltagent_searchpod.yaml with the proper values"
  echo "to run dlltagent and monitor he network communication of the appropriate pod."
  echo "usage: monitorPod.sh pod [namespace] [interface]"
  echo 
  echo "You need to indicate the pod, namespace, and optionaly interface to monitor. Default interface is pod's eth0"
  echo "dlltagen will run in same namespace as the pod. If you need to change it, you cna change it manually in the output yaml file."
  echo "Please do not modify the original dlltagent_pod.yaml"
  echo
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         help
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
         help
         exit;;
   esac
done

if [[ -z "$1" ]];
then
  echo "Error: First parameter must be pod name"
  help
  exit 1
else
  POD_NAME=$1
fi

if [[ -z "$2" ]];
then
  echo "Namespace not specified. Using default."
else
  NAMESPACE=$2
fi

if [[ -z "$3" ]];
then
  echo "Pod's interface not specified. Using default."
else
  INTERFACE=$3
fi

echo "Configuring yaml for pod ${POD_NAME}, namespace ${NAMESPACE}, interface ${INTERFACE}"

#PATH=$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin
#/sbin/ip addr

VINTERF=$(kubectl exec -it ${POD_NAME} -n${NAMESPACE} -- env PATH=$PATH:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin ip addr | grep eth0@ | sed "s/^.*\(${INTERFACE}@if\)\([0-9]*\):.*$/\2/")
NODE=$(kubectl get pod ${POD_NAME} -n${NAMESPACE} -o=custom-columns=:.spec.nodeName | grep [[:alnum:]])
echo "NODE: $NODE"
echo "VIRTUAL INTERFACE: $VINTERF"

sed -e "s/345345345/${VINTERF}/" -e "s/default345/${NAMESPACE}/" -e "s/changeNodeName/${NODE}/" dlltagent_pod.yaml > ${OUTPUT_FILE}

echo "Generated file ${OUTPUT_FILE}. You can apply this file"

#kubectl apply -f dlltagent_searchpod.yaml


