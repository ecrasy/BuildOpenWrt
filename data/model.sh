#########################################################################
# File Name: data/model.sh
# Author: Carbon (ecras_y@163.com)
# Description: replace default model string with empty string
# Created Time: 2022-07-25 01:30:41 UTC
# Modified Time: 2022-10-01 11:02:32 UTC
#########################################################################


#!/bin/bash

str="Default string Default string/Default string - "
rpl=""
cmd=s@$str@$rpl@
sed -i "$cmd" /tmp/sysinfo/model

