while true
do 
	i=`cat /tmp/endpoint`
	status=`curl -s -o /dev/null -w  "%{http_code}" http://$i`
	if [ $status -eq 200 ]; then 
		echo "Smoke Successfull"
		break;
	else 
		echo "......"
	fi
done
