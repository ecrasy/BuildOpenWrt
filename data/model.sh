#########################################################################
# File Name: data/model.sh
# Author: Carbon (ecras_y@163.com)
# Description: replace default model string with empty string
# Created Time: 2022-07-25 01:30:41 UTC
# Modified Time: 2022-07-25 01:31:41 UTC
#########################################################################


#!/bin/bash

model="Default string Default string/Default string - "
str=""
command=s@$model@$str@
sed -i "$command" /tmp/sysinfo/model

