#!/bin/bash

source deploy/colorcodes.sh

LOGIN_RESULT=""
TARGET_RESULT=""

IBM_API_ENDPOINT="https://cloud.ibm.com"
if [ "$DEPLOYMENT_ENV" = "stage" ] || [ "$DEPLOYMENT_ENV" = "STAGE" ]; then
	IBM_API_ENDPOINT="https://test.cloud.ibm.com"
fi

LOGIN_RESULT="`ibmcloud login --apikey $DEPLOYMENT_IAM_API_KEY -a $IBM_API_ENDPOINT --no-region`"
if [[ $LOGIN_RESULT == *"FAILED"* ]]; then
	echo "$LOGIN_RESULT"
	echo -e "${Red} Error with ibmcloud login. check the logs above. ${RCol}"
	exit 1
else
	echo "$LOGIN_RESULT"
	echo ""
fi
TARGET_RESULT="`ibmcloud target -g $ICR_RESOURCE_GROUP`"
if [[ $TARGET_RESULT == *"FAILED"* ]]; then
	echo "$TARGET_RESULT"
	echo -e "${Red} Error with ibmcloud target. check the logs above. ${RCol}"
	exit 1
else
	echo "$TARGET_RESULT"
	echo ""
fi

readarray -d / -t strarr <<<"$BROKER_ICR_NAMESPACE_URL"
NAMESPACE=${strarr[1]}

echo "checking namespace."
echo "new namespace will be created if failed to find namespace with name $NAMESPACE"
create_namespace=`ibmcloud cr namespace-add -g $ICR_RESOURCE_GROUP $NAMESPACE`

if [[ $create_namespace == *"OK"* ]]; then
	echo -e "${Gre} Ok
	${RCol}"
else
	echo "$create_namespace"
	echo -e "${Red}Error with namespace creation. check the logs above. ${RCol}"
	exit 1
fi
