#!/bin/sh
#REQUIREMENTS
#Add the IP of the networkprinter to the env var 'brother_ql_address'
#Install qrencode: https://fukuchi.org/works/qrencode/
#Install brother_ql: https://pypi.org/project/brother-ql/

guid=$(uuidgen)
filename="output/${guid}.png"
brother_ql_address=${BROTHER_QL_ADDR}
brother_ql_model="QL-710W"
brother_ql_label="29"
#Name      Printable px   Description
#12         106           12mm endless
#29         306           29mm endless
#38         413           38mm endless
#50         554           50mm endless
#54         590           54mm endless
#62         696           62mm endless
#62red      696           62mm endless (black/red/white)
#102       1164           102mm endless
#17x54      165 x  566    17mm x 54mm die-cut
#17x87      165 x  956    17mm x 87mm die-cut
#23x23      202 x  202    23mm x 23mm die-cut
#29x42      306 x  425    29mm x 42mm die-cut
#29x90      306 x  991    29mm x 90mm die-cut
#39x90      413 x  991    38mm x 90mm die-cut
#39x48      425 x  495    39mm x 48mm die-cut
#52x29      578 x  271    52mm x 29mm die-cut
#62x29      696 x  271    62mm x 29mm die-cut
#62x100     696 x 1109    62mm x 100mm die-cut
#102x51    1164 x  526    102mm x 51mm die-cut
#102x152   1164 x 1660    102mm x 153mm die-cut
#d12         94 x   94    12mm round die-cut
#d24        236 x  236    24mm round die-cut
#d58        618 x  618    58mm round die-cut


printQrCode () {
  qrencode -t PNG "${guid}" -o "${filename}" - i -s 7 -m 3 -l H
  #this results in a qr code image with dimensions 273px x 273px
  echo "${guid} saved as '${filename}'"

  brother_ql -m "${brother_ql_model}" -b network -p "tcp://${brother_ql_address}:9100" print -l "${brother_ql_label}" "${filename}"

  echo "'${filename}' printed on '${brother_ql_address}' (Type: '${brother_ql_model}')"
}

numberOfQrCodes=1

if [ $# -gt 0 ]
then
  numberOfQrCodes=$1
fi

for (( i=0; i<numberOfQrCodes; i++ ))
do
  echo "Print QR-Code $((i+1))"
  printQrCode
done