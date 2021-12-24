#!/bin/sh

STARTUP=0

for i in {1..300} ; do
  curl 127.0.0.1:19098 > /dev/null 2>&1
  if [ $? == 0 ]; then
      STARTUP=1
      break
     else
       sleep 1
  fi
done

if [ $STARTUP -eq 0  ]; then
  echo server not startup
  exit 1
fi

ADDONS=`vela addon list |awk 'NR>1'|awk '{print $1}'` | sort

vela addon list

exit_code=0
for i in $ADDONS ; do
    if [ $i == "observability" ]; then
      vela addon enable $i domain=abc.com
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