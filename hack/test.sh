#!/bin/bash
for x in traits/*/
do
  [[ -d "$x" ]] || break
  [[ -f "$x"/Makefile ]] || break
  echo "run test for $x"
  cd $x && make test
done

for x in workloads/*/
do
  [[ -d "$x" ]] || break
  [[ -f "$x"/Makefile ]] || break
  echo "run test for $x"
  cd $x && make test
done
