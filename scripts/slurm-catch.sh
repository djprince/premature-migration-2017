#!/bin/bash -l

x=1
while [ $x -gt 0 ] 
do
sleep 1m
x=$(smap -c | grep $1 | wc -l)
done
