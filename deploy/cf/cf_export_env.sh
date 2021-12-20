#!/bin/bash

ICR_BASE=icr.io
if [ "$ONBOARDING_ENV" = "stage" ] || [ "$ONBOARDING_ENV" = "STAGE" ]; then
	ICR_BASE=stg.icr.io
fi

CONFIG_FILE=deploy/cf/cf.config.properties
C_APP_NAME=`cat ${CONFIG_FILE} | grep PREFIX | cut -d'=' -f2`-app
C_CF_API=`cat ${CONFIG_FILE} | grep CF_API | cut -d'=' -f2`
C_CF_ORGANIZATION=`cat ${CONFIG_FILE} | grep CF_ORGANIZATION | cut -d'=' -f2`
C_CF_SPACE=`cat ${CONFIG_FILE} | grep CF_SPACE | cut -d'=' -f2`
C_BROKER_USERNAME=`cat ${CONFIG_FILE} | grep BROKER_USERNAME | cut -d'=' -f2`
C_BROKER_PASSWORD=`cat ${CONFIG_FILE} | grep BROKER_PASSWORD | cut -d'=' -f2`
C_BROKER_ICR_NAMESPACE_URL=$ICR_BASE/`cat ${CONFIG_FILE} | grep PREFIX | cut -d'=' -f2`-namespace
C_ICR_IMAGE=`cat ${CONFIG_FILE} | grep PREFIX | cut -d'=' -f2`-img
C_ONBOARDING_ENV=`cat ${CONFIG_FILE} | grep ONBOARDING_ENV | cut -d'=' -f2`
C_PC_URL=`cat ${CONFIG_FILE} | grep PC_URL | cut -d'=' -f2`

EMPTY='""'

getVar()
{
	cVarName="C_$1"
	if [ -z ${!1} ] || [ ${!1} == $EMPTY ]
	then
		echo "${!cVarName}"
	else
		echo "${!1}"
	fi
}

getGenVar()
{
	cVarName="C_$1"
	echo "${!cVarName}"
}

echo "APP_NAME=$(getGenVar APP_NAME)
BROKER_USERNAME=$(getVar BROKER_USERNAME)
BROKER_PASSWORD=$(getVar BROKER_PASSWORD)
BROKER_ICR_NAMESPACE_URL=$(getGenVar BROKER_ICR_NAMESPACE_URL)
ICR_IMAGE=$(getGenVar ICR_IMAGE)
CF_API=$(getVar CF_API)
CF_ORGANIZATION=$(getVar CF_ORGANIZATION)
CF_SPACE=$(getVar CF_SPACE)
ONBOARDING_ENV=$(getVar ONBOARDING_ENV)
PC_URL=$(getVar PC_URL)" > deploy/cf/cf.config.temp.properties
