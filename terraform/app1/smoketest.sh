n=1
while true
do 
	i=`cat /tmp/endpoint`
	status=`curl -s -o /dev/null -w  "%{http_code}" http://$i`
	if [ $status -eq 200 ]; then 
		echo "SmokeTest Successfull"
		break;
	else 
		echo "......"
                sleep 10
                n=$(( n+1 ))
                if [ $n -gt 30 ]; then
                    echo "SmokeTest failed"
                    break;
                fi
	fi
done
