## docker启动hadoop集群
1. 执行 ``` bash start-file.sh```启动，
    第一次启动时需要下载镜像会比较慢，之后都会很快启动起来，
    访问宿主机ip:50070可以查看
2. 需要改变workers的数量时在start-file.sh 中第9行
    ```bash ./start-container.sh```传入参数即可，或者手动修改文件