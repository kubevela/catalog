#!/bin/bash

for x in traits/experimental/*
do
  [[ -e "$x" ]] || break  # handle the case of no *.wav files
  echo "run test for $x"
  cd $x && make all
done

for x in workloads/experimental/*
do
  [[ -e "$x" ]] || break  # handle the case of no *.wav files
  echo "run test for $x"
  cd $x && make build
done
