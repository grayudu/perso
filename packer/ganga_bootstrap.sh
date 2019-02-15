#!/bin/bash -x

# retry to get the instance-id
n=0
until [ $n -ge 5 ]
do
_id=$(curl --silent "http://169.254.169.254/latest/meta-data/instance-id") && test ! -z $_id && export ID=$_id && break
n=$[$n+1]
sleep 15
done

echo $_id

