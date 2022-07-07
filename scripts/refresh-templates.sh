#!/bin/bash
set -eo pipefail

Help()
{
   # Display Help
   echo
   echo "Refresh GW Templates from the current directory to the default kubectl cluster."
   echo
   echo "Syntax: $0 [-4] [-s systemname] [-h] NAMESPACE"
   echo "parameters:"
   echo " NAMESPACE - User Namespace (raw, i.e., without \"epic-\" prefix)."
   echo "options:"
   echo " -4     Refresh both IPV6 and IPV4 templates (default is IPV6 only)."
   echo " -s     System name (default is \"uswest\")."
   echo " -h     Print this Help."
   echo
}

SYSTEM=uswest
NS=""

while [ $# -gt 0 ]
do
    unset OPTIND
    unset OPTARG
    while getopts s:4h option
    do
        case $option in
            4) RefreshV4="yes"
               ;;

            s) SYSTEM=$OPTARG
               ;;

            h) Help
               exit 1
               ;;

            \?) Help    # invalid input
                exit 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    # See if we've got a positional parameter. There's only one.
    if [ "X$1" != "X" ] ; then
        NS=$1
        shift
    fi
done

if [ "X${NS}" == "X" ] ; then
   echo "Error: namespace must be provided"
   Help
   exit 1
fi

echo "Refreshing templates in $NS namespace, using system name $SYSTEM..."

# Do two old-school text substitutions to make the yaml fit the
# environment. First, we need to substitute the USERNAMESPACE so the
# LBSG ends up in the proper namespace. Second, we need to change
# "uswest" to the system name so requests are marked with the
# appropriate "Via:" headers.
sed -e "s/USERNAMESPACE/$NS/" -e "s/uswest/$SYSTEM/" lbsg_gatewayhttpv6.yaml | kubectl apply -f -
sed -e "s/USERNAMESPACE/$NS/" -e "s/uswest/$SYSTEM/" lbsg_gatewayhttpsv6.yaml | kubectl apply -f -
sed -e "s/USERNAMESPACE/$NS/" -e "s/uswest/$SYSTEM/" lbsg_istiohttpv6.yaml | kubectl apply -f -
sed -e "s/USERNAMESPACE/$NS/" -e "s/uswest/$SYSTEM/" lbsg_istiohttpsv6.yaml | kubectl apply -f -

if [ "X$RefreshV4" == "Xyes" ] ; then
sed -e "s/USERNAMESPACE/$NS/" -e "s/uswest/$SYSTEM/" lbsg_gatewayhttp.yaml | kubectl apply -f -
sed -e "s/USERNAMESPACE/$NS/" -e "s/uswest/$SYSTEM/" lbsg_gatewayhttps.yaml | kubectl apply -f -
sed -e "s/USERNAMESPACE/$NS/" -e "s/uswest/$SYSTEM/" lbsg_istiohttp.yaml | kubectl apply -f -
sed -e "s/USERNAMESPACE/$NS/" -e "s/uswest/$SYSTEM/" lbsg_istiohttps.yaml | kubectl apply -f -
fi
