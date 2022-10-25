#########################################################################
# File Name: model.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: replace default model string with empty string
# will be called in wlan up event
# Created Time: 2022-07-25 01:30:41 UTC
# Modified Time: 2022-10-24 04:18:51 UTC
#########################################################################


#!/bin/bash

str="Default string Default string/Default string - "
rpl="Intel(R) J4125 - "
cmd="s@$str@$rpl@"
sed -i "$cmd" /tmp/sysinfo/model

str="Default string Default string"
rpl="Intel(R) J4125"
cmd="s@$str@$rpl@"
sed -i "$cmd" /tmp/sysinfo/model

