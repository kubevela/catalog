#!/bin/sh

ADDONS=`ls './addons'`

vela addon list

exit_code=0
for i in $ADDONS ; do
    if [ $i == "observability" ]; then
      echo skip # currently observability addon  has some chances to fail, @zzxwill will fix this issue and
      else
      vela addon enable $i
    fi

    if [ $? -ne 0 ]; then
      echo -e "\033[31m addon $i cannot enable \033[0m"
      exit_code=1
    else
      echo -e "\033[32m addon $i enable successfully \033[0m"
    fi
done

exit $exit_code