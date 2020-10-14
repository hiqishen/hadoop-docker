#!/bin/bash

echo "start build zyz_hadoop image..."
sudo docker build -t zyz_hadoop .

if [[ $? -eq 0 ]];then
  echo "build image success"
  echo "start run container"
  bash ./start-container.sh
else
    echo -e "build image fail \n will exit"
fi