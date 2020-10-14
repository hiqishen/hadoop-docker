#!/bin/bash

# the default node number is 3
N=${1:-3}

ssh_auth_p=~/hadoop
ssh_auth=${ssh_auth_p}/authorized_keys
slaves_p=~/hadoop
slaves=${slaves_p}/slaves
mkdir -p $ssh_auth_p
mkdir -p $slaves_p

image=zyz_hadoop
HADOOP_HOME=/usr/local/hadoop

echo -n "" > $slaves
echo -n "" > $ssh_auth
sudo chown -R 777 $ssh_auth
sudo chown -R 777 $slaves

sudo docker network create --driver=bridge hadoop
# start hadoop master container
sudo docker ps -a | grep hadoop |awk '{print $1}' | xargs docker rm -f &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                -h hadoop-master \
                -v $slaves:$HADOOP_HOME/etc/hadoop/slaves \
                $image &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
  echo hadoop-slave$i >> $slaves
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                -h hadoop-slave$i \
                  -v $slaves:$HADOOP_HOME/etc/hadoop/slaves \
	                $image &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master ./start-hadoop.sh
