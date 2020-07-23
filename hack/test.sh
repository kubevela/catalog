#!/bin/bash
for x in traits/*/
do
  [[ -d "$x" ]] || break
  [[ -f "$x"/Makefile ]] || break
  echo "run test for $x"
  make test -C $x
done

for x in workloads/*/
do
  [[ -d "$x" ]] || break
  [[ -f "$x"/Makefile ]] || break
  echo "run test for $x"
  make test -C $x
done
