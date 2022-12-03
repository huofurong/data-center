# **城市算力中心开发者门户部署说明**
[TOC]

## 一、硬件要求

### 1.1. 最小配置

| 服务  | CPU  |Memory| Disk ||
| ----- | ----- |----- |----- |----- |
|门户系统前端，运营管理系统前端，Nginx，算力中心OpenAPI | 2  | 8  |200GB| 1台
| 门户系统后端、运营管理系统后端及相关微服务 | 4 |16 |300GB| 1台
| 链服务，[kong网关](https://github.com/BSN-DDC/ddc-kong-gateway)    | 2  | 8  |200GB| 1台
| 数据库，缓存服务，Sftp | 4  | 8  |200GB| 1台

### 1.2. 建议配置

| 服务  | CPU  |Memory| Disk ||
| ----- | ----- |----- |----- |----- |
|门户系统前端，运营管理系统前端，Nginx，算力中心OpenAPI | 4 | 8  |200GB| 1台
| 门户系统后端、运营管理系统后端及相关微服务 | 8 |32 |500GB| 1台
| 链服务，[kong网关](https://github.com/BSN-DDC/ddc-kong-gateway)   | 8  | 16  |200GB| 1台
| 数据库，缓存服务，Sftp | 8  | 16  |200GB| 1台

## 二、环境要求

| 软件  | 版本  | Docker Image|
| ----- | ----- | ----- |
| MySQL | 5.7+  |mysql:5.7.39|
| Redis | 6.0.5 |redis:6.0.5|
| Nginx | 1.21.4.1 |openresty/openresty:latest|
| Nacos | 2.1.2 |nacos:2.1.2|
| Sftp |version3+|atmoz/sftp:latest|
| docker-ce | 20.10.21+ |-|
| docker-compose | 1.29.0+ |-|


## 三、环境准备

### 3.1. 常用命令

```shell
# 安装常用包-可添加根据实际需求
yum install -y lrzsz tree jq

# 安装docker-compose 1.29.0
curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
source /etc/profile

# 升级docker-ce
yum remove -y docker  docker-common docker-selinux docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

# 调整docker镜像、容器的存储位置（用于挂载了数据盘的服务器）
mv /var/lib/docker /bsn/docker
mv /var/lib/docker /bsn/docker
ln -s /bsn/docker /var/lib/docker
systemctl enable docker
systemctl start docker

```

### 3.2. 磁盘挂载（参考）

```shell
fdisk -l 
fdisk /dev/sdb
mkfs.xfs /dev/sdb1
mkdir /bsn
echo "/dev/sdb1 /bsn xfs defaults 0 0" >> /etc/fstab
```

## 四、服务安装

### 4.1. 获取安装包

- [jar包下载地址](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/packages)：git clone  

| 服务标识 |  服务说明     | 环境要求 |
| -------- | ------------ | ------- |
| nacos |        微服务      | Oracle JDK11  x64 |
| ddc-opsjob |        运营job      | Oracle JDK11  x64 |
| ddc-auth |   运营权限服务 | Oracle JDK11  x64          |
| ddc-swap-api |交易服务     | Oracle JDK11  x64         |
| ddc-swap-job |交易job服务  | Oracle JDK11  x64         |
| ddc-base |基础服务  | Oracle JDK11  x64         |
| ddc-account |帐户服务  | Oracle JDK11  x64         |
| ddc-ops |运营系统后端服务  | Oracle JDK11  x64         |
| ddc-portal |门户后端服务  | Oracle JDK11  x64         |
| ddc-oai |算力中心OpenAPI | Oracle JDK11  x64  |
| ddc-chainsrv-zhongyi | 中移链服务 | Oracle JDK1.8  x64 |
| ddc-chainsrv-wenchang | 文昌链服务 | Oracle JDK1.8  x64 |
| ddc-chainsrv-taian | 泰安链服务 | Oracle JDK1.8  x64 |
| portal-web | 门户前端页面 |  |
| operation-web | 运营系统前端页面 |  |

### 4.2. 服务部署流程

1、基础数据库：MySQL、Redis、Sftp  
2、java微服务：Nacos、链服务（包括文昌链链服务、中移链服务、泰安链服务）、后端相关微服务  （包括运营job、运营权限服务、交易服务 、交易job服务、基础服务、帐户服务、运营系统后端服务 、门户后端服务）  
3、门户、运营系统前端，算力中心OpenAPI  

### 4.3. MySQL部署

#### 4.3.1. MySQL安装包目录结构

- 数据库初始化脚本：[mysql-schema.sql](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/database/mysql)
- Mysql应用启动文件：[mysql](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/config-files/dockerAndShell/Base/mysql)
```shell
mkdir $PWD/mysql/script
# 按照下述结构创建文件夹，并将下载好的配置文件和脚本放至指定目录
mysql
├── conf
│   └── my.cnf
├── data
├── docker-compose.yml
└── script
    └── mysql-schema.sql
```

#### 4.3.2. 启动MySQL

```shell
#下载镜像
docker pull mysql:5.7.39

#创建docker-compose.yaml
cat >> docker-compose.yaml <<EOF
version: '3'
services:
  mysql:
    image: mysql:5.7.39
    restart: always
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: xxx # 数据库密码，自己设置
      TZ: Asia/Shanghai
    ports:
      - 3306:3306
    volumes:
      - \$PWD/data:/var/lib/mysql
      - \$PWD/conf/my.cnf:/etc/mysql/my.cnf
      - \$PWD/script:/mysql-script
    command:
      --max_connections=100000
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_general_ci
      --default-authentication-plugin=mysql_native_password
EOF

#启动
cd $PWD/mysql
docker-compose up -d
```

#### 4.3.3. 数据验证

```shell
docker exec -it mysql bash
mysql -uroot -p<mysql-password>
# 数据初始化
mysql> source /mysql-script/mysql-schema.sql
...
mysql> show databases;
mysql> use ddc_xxxxx;
mysql> show tables;
...
```

### 4.4. Nacos部署

#### 4.4.1. Nacos安装包目录结构

- Nacos应用启动配置文件：[application.properties](https://github.com/BSN-DDC/computingpower/blob/main/deployPackageAndConfiguration/config-files/dockerAndShell/Base/nacos/conf/application.properties)
- Nacos应用启动文件：[Nacos](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/config-files/dockerAndShell/Base/nacos)

```shell
mkdir -p $PWD/nacos/{conf,data,logs,plugins}
# 按照如下目录结构创建文件夹，把application.properties放置conf文件夹内
nacos
├── conf
│   └── application.properties
├── data
├── docker-compose.yml
├── logs
└── plugins
```

#### 4.4.2. 启动Nacos

```shell
#创建docker-compose.yaml
cat >> docker-compose.yaml <<EOF
version: '3'
services:
  nacos:
    image: 'nacos/nacos-server:v2.1.2'
    container_name: 'nacos'
    restart: always
    ports:
      - 8848:8848
      - 9848:9848
      - 7848:7848
      - 9849:9849
    environment:
      - PREFER_HOST_MODE=hostname
      - MODE=standalone
    volumes:
      - \$PWD/logs/:/home/nacos/logs
      - \$PWD/plugins/:/home/nacos/plugins
      - \$PWD/data/:/home/nacos/data
      - \$PWD/conf/application.properties:/home/nacos/conf/application.properties
EOF

#启动
cd $PWD/nacos
docker-comopse up -d
```

#### 4.4.3. 创建nacos命名空间

**命令行创建**

```shell
# customNamespaceId=ddc_hashrate_system 命名空间为固定
# namespaceName=ddc_hashrate_system  
curl -X POST 'http://{NACOS-HOST}:8848/nacos/v1/console/namespaces' -d 'customNamespaceId=ddc_hashrate_system&namespaceName=ddc_hashrate_system&namespaceDesc=算力中心平台'
```
**页面创建**  

打开Nacos页面，默认端口是8848，默认登录名和密码：nacos/nacos，登录页面点击【命名空间】-【新建命名空间】，命名空间ID(不填则自动生成)必须填写成【ddc_hashrate_system】，命名空间名必须填写成【ddc_hashrate_system】。

#### 4.4.4 下载应用服务端配置文件

- 应用服务端配置文件压缩包下载：[github地址](github地址)

##### 4.4.4.1. 配置清单

配置具体说明请参考文件里的属性描述

| 配置名称 | 配置说明 |
| -------- | ------------ |
| ddc-swap-job.yaml | 交易服务定时配置 |
| system-config.yaml | 全局属性 |
| ddc_server_port_default.yml | 服务端口配置 |
| redis-common.yaml | redis配置 |
| mysql-jdbc-common.yaml | mysql配置 |
| ddc-web-common.yml | 门户，运营服务配置 |
| ddc-web-sftp.yml | sftp配置 |
| ddc-web-email.yml | 邮件服务配置 |
| kong-gateway-config.yml | 节点网关客户端配置；  注意： |
| ddc-chainsrv-{链名称全拼}.yaml | 链服务配置： |

kong客户单配置可以从nacos或者运营系统修改。kong-gateway-config.yml

```yaml
  kong:
    #网关中创建的consumers中Basic Auth用户名与密码
    password: "abc123"
    #修改后链服务需要重启
    api-key: "hashratee51840118927d62263437c8deaade5ce1253452ea1a3da3784aa80ff"
    #网关中创建的consumers中Basic Auth用户名与密码
    user-name: "admin"
    tps: 20
    tpd: 5000000
    #修改后链服务需要重启
    base-address: "http://10.0.51.204:18601/"
    #修改后链服务需要重启 必须是 ip:port 格式，前缀不要加任何协议
    base-address-grpc: "10.0.51.204:18602"
    #修改后链服务需要重启
    base-address-websocket: "http://10.0.51.204:18602/"

```



##### 4.4.4.2. 导入应用服务配置到nacos

1- 通过Nacos控制台页面【配置管理】-【配置列表】-【ddc_hashrate_system】导入应用服务端配置文件压缩包2- 注意配置文件需导入到【ddc_hashrate_system】空间，不要导入public(保留空间)。
3- 关于更多的nacos控制台说请参考[nacos官方文档](https://nacos.io/zh-cn/docs/console-guide.html)

### 4.5. Redis部署

#### 4.5.1. Redis安装包目录结构

- redis6应用启动配置文件：[redis.conf](https://raw.githubusercontent.com/redis/redis/6.0/redis.conf)
- redis应用启动文件：[redis](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/config-files/dockerAndShell/Base/redis)
```shell
mkdir -p $PWD/redis/{conf,data,logs}
# 按照如下目录结构创建文件夹，把redis.conf放置conf文件夹内
redis
├── conf
│   └── redis.conf
├── data
├── docker-compose.yml
└── logs
```

#### 4.5.2. 启动Redis

```shell
# 处理系统内核
echo "net.core.somaxconn=1024" >> /etc/sysctl.conf
echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
chmod +x /etc/rc.local
source /etc/rc.local
sysctl -p

#创建 docker-compose.yaml
cat >> docker-compose.yaml <<EOF
version: '3'
services:
  redis:
    image: 'redis:6.0.5'
    container_name: 'redis'
    restart: always
    tty: true
    volumes:
      - \$PWD/data:/data
      - \$PWD/conf/redis.conf:/etc/redis/redis.conf
      - \$PWD/logs:/logs
    ports:
      - 6379:6379
    command:
      - /bin/bash
      - -c
      - |
        echo 1024 > /proc/sys/net/core/somaxconn
        redis-server --requirepass "redis6379"
    privileged: true
EOF

# 启动
cd $PWD/redis
docker-compose up -d
```

### 4.6. Sftp部署

#### 4.6.1. Sftp安装包目录结构
- sftp应用启动文件：[sftp](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/config-files/dockerAndShell/Base/sftp)
```shell
# 按照如下目录结构创建文件夹
sftp
├── data
├── docker-compose.yml
└── user
    └── users.conf
# 编写配置文件
# 用户名:密码:::存储路径2
echo "test:test:::upload" >> $PWD/redis/user/users.conf
```

#### 4.6.1. 启动Sftp

```shell
#创建docker-compose.yaml
cat >> docker-compose.yaml <<EOF
version: '3'
services:
  ftp:
    image: atmoz/sftp
    container_name: sftp
    restart: always
    volumes:
        - \$PWD/redis/data:/home/
        - \$PWD/redis/user/users.conf:/etc/sftp/users.conf
    ports:
        - "8012:22"
EOF

#启动
cd $PWD/redis
docker-compose up -d
```

### 4.7. 链服务安装

#### 4.7.1. 服务目录结构
- 链服务启动文件：[ChainSrv](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/config-files/dockerAndShell/Chain-Srv)
```shell
# 链服务目录结构，解压后自然生成
tar -xzvf ChainService.tar.gz
taianchain-ddc-service
├── docker-compose.yml
├── pkg
└── script
    └── start.sh
wenchangchain-ddc-service
├── docker-compose.yml
├── pkg
└── script
    └── start.sh
zhongyichain-ddc-service
├── docker-compose.yml
├── pkg
└── script
    └── start.sh
```

#### 4.7.2. docker镜像准备
- [oraclejdk8下载地址【官方地址】](https://www.oracle.com/java/technologies/downloads/#java8)

##### 4.7.2.1. JDK8镜像准备

```shell
# 准备jdk文件，以下文件测试实际可用
jdk-8u351-linux-x64.tar.gz
# 创建Dockefiles
cat >> Dockerfile <<EOF
FROM centos:7.9.2009
RUN yum reinstall -y glibc-common && \
    yum install -y  kde-l10n-Chinese fontconfig dejavu-sans-fonts telnet && \
    yum clean all && \
    rm -rf /var/cache /tmp/* && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && \
    fc-cache -f
RUN mkdir /usr/local/java
ADD jdk-8u351-linux-x64.tar.gz /usr/local/java/
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8
# 注意解压后的目录名称
ENV JAVA_HOME /usr/local/java/jdk1.8.0_351
ENV PATH \$JAVA_HOME/bin:\$PATH
VOLUME /tmp 
EOF
```


#### 4.7.3. 链服务启动

```shell

# 修改start.sh启动脚本
bash $PWD/set-nacos-address.sh
# 手动输入
Please enter the nacos server address: <nacos服务器地址>
Please enter the nacos server port: <nacos服务器web端口>

#创建docker-compose.yaml
cat >> docker-compose.yaml <<EOF
version: "3"
services:
  ddc-chainsrv-<ChainName>-service:
    image: java8:1.8.0_351
    container_name: ddc-chainsrv-<ChainName>-service
    working_dir: /bsn/chainService
    restart: always
    network_mode: host
    # ports:
    #   - 32020:32020
    volumes:
      - \$PWD/pkg/ddc-chainsrv-<ChainName>.jar:/bsn/chainService/ROOT.jar
      - /bsn/ddclogs/:/bsn/ddclogs
      - \$PWD/script/:/bsn/script
      - /etc/hosts:/etc/hosts
      - /etc/localtime:/etc/localtime
    environment:
      # 指定时区
      - TZ=Asia/Shanghai
    command: sh /bsn/script/start.sh 
EOF

#启动
cd $PWD/ddc-chainsrv-<ChainName>
docker-compose up -d

```

### 4.8. 后端相关微服务安装

#### 4.8.1. docker镜像准备
- [oraclejdk11下载地址【官方地址】](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html)
##### 4.8.1.1. JDK11镜像准备
```shell
# 准备jdk文件，以下版本经过测试实际可用
jdk-11.0.16.1_linux-x64_bin.tar.gz
# 创建Dockerfile
cat >> Dockerfile <<EOF
FROM centos:7.9.2009
RUN yum reinstall -y glibc-common && \
    yum install -y  kde-l10n-Chinese fontconfig dejavu-sans-fonts telnet && \
    yum clean all && \
    rm -rf /var/cache /tmp/* && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && \
    fc-cache -f
RUN mkdir /usr/local/java
ADD jdk-11.0.16.1_linux-x64_bin.tar.gz /usr/local/java/
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8
# 注意解压后的目录名称
ENV JAVA_HOME /usr/local/java/jdk-11.0.16.1
ENV PATH \$JAVA_HOME/bin:\$PATH
VOLUME /tmp 
EOF
# 编译打包镜像
docker build -t java11-cn:11.0.16.1 .
```

#### 4.8.2. 服务启动目录

- 后端相关微服务启动文件：[DDC-Srv](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/config-files/dockerAndShell/DDC-Srv)

```shell
# 创建日志路径
mkdir -p /bsn/ddclogs
tar -xzvf ChainService.tar.gz
# 如下是整个微服务后端的目录结构，解压ChainService.tar.gz后自动生成，pkg目录需要创建
# 创建用于存放微服务jar包的目录
mkdir -p /bsn/{account-ddc,base-ddc,ops-ddc,opsauth-ddc,opsjob-ddc,portal-ddc,swap-api,swap-job}/pkg
tree -L 2 /bsn
bsn
├── account-ddc
│   ├── pkg
│   └── script
├── base-ddc
│   ├── pkg
│   └── script
├── ddclogs
├── opsauth-ddc
│   ├── pkg
│   └── script
├── ops-ddc
│   ├── pkg
│   └── script
├── opsjob-ddc
│   ├── pkg
│   └── script
├── portal-ddc
│   ├── pkg
│   └── script
├── swap-api
│   ├── pkg
│   └── script
└── swap-job
    ├── pkg
    └── script
```

#### 4.8.3. 配置启动文件Nacos服务器地址+端口号

```shell
# 切换路径
cd /bsn

# 批量设置微服务start.sh的对应的nacos地址
bash set-nacos-address.sh
Please enter the nacos server address: <nacos服务器地址>
Please enter the nacos server port: <nacos服务器web端口>
```

#### 4.8.4. 启动微服务

**单个服务独立启动**（用于微服务部署在多台服务器）

```shell
#切换到单独微服务
#创建docker-compose.yaml文件
cat >> docker-compose.yaml <<EOF
# <service_name> 服务名称例如ops-ddc
version: "3"
services:
  ddc-<service_name>-service:
    image: java11-cn:11.0.16.1
    container_name: ddc-<service_name>
    working_dir: /bsn/ddc-<service_name>
    restart: always
    network_mode: host
    # ports:
    #   - 38021:38021
    volumes:
      - \$PWD/pkg/ddc-<service_name>.jar:/bsn/ddc-<service_name>/ROOT.jar
      - /bsn/ddclogs/:/bsn/ddclogs/
      - \$PWD/script/:/bsn/script
      - /etc/hosts:/etc/hosts
      - /etc/localtime:/etc/localtime
    environment:
      # 指定时区
      - TZ=Asia/Shanghai
    command: sh /bsn/script/start.sh
 EOF

# 启动微服务
cd /bsn/ddc-<service_name>
docker-compose up -d
```
**一键启动**（用于微服务部署在一台服务器，不包含算力中心OpenApi）
```shell
#创建docker-compose.yaml文件
cat >> docker-compose.yaml <<EOF
version: "3"
services:
  #将一个个单一服务放到一起
  ddc-<service_name>:
    image: java11-cn:11.0.16.1
    ...

  ddc-<service_name>:
    image: java11-cn:11.0.16.1
       
EOF

# 启动微服务
cd /bsn
docker-compose up -d
```

#### 4.8.5. 算力中心OpenApi启动

- 算力中心OpenApi服务启动文件：[ddc-oai](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/config-files/dockerAndShell/DDC-Srv/ddc-oai)

```shell
# 目录结构
saasapi-ddc/
├── docker-compose.yml
├── pkg
├── logs
└── script
    └── start.sh
# 创建docker-compose
cat >> docker-compose.yml <<EOF
version: "3"
services:
  ddc-oai-service:
    image: java11-cn:11.0.16.1
    container_name: ddc-oai
    working_dir: /bsn/ddc-oai
    restart: always
    network_mode: host
    # ports:
    #   - 18080:18080
    volumes:
      - \$PWD/pkg/ddc-oai.jar:/bsn/ddc-oai/ROOT.jar
      - \$PWD/ddclogs/:/bsn/ddclogs/
      - \$PWD/script/:/bsn/script
      - /etc/hosts:/etc/hosts
      - /etc/localtime:/etc/localtime
    environment:
      # 指定时区
      - TZ=Asia/Shanghai
    command: sh /bsn/script/start.sh
EOF
# 将启动的jar包放至pkg目录
# 将start.sh放至$PWD/ddc-oai/script/ 下，注意修改nacos服务器地址+端口号
cat >>$PWD/ddc-oai/script/start.sh<<EOF
java -Xms1G -Xmx2G -jar /bsn/ddc-oai/ROOT.jar \
--nacos.config.namespace=ddc_hashrate_system \
--nacos.config.server-addr=X.X.X.X:XXXX
EOF

docker-compose up -d
```


### 4.9. 前端页面部署

#### 4.9.1. 服务目录结构

- nginx启动文件：[ddc-nginx](https://github.com/BSN-DDC/computingpower/tree/main/deployPackageAndConfiguration/config-files/dockerAndShell/DDC-Nginx)

```shell
mkdir -p $PWD/operesty-nginx/{conf,html,logs,ssl,stream}
mkdir -p $PWD/operesty-nginx/html/{operation,portal}
# 按照如下文件夹结构进行配置
operesty-nginx
├── conf
│   ├── ip_white.conf，需要放ip_white吗，现在是没生效的
│   └── nginx.conf
├── docker-compose.yml
├── html
│   ├── operation #运营前端文件夹，将下载后dist目录拷贝到此处
│   └── portal    #门户前端文件夹，将下载后dist目录拷贝到此处
├── logs
├── ssl
└── stream
    ├── jsonlog.lua
    ├── openapi-saas.conf
    ├── operation.conf
    ├── portal.conf
    ├── share-proxy.conf
    └── status.conf
```


#### 4.9.2. 配置文件部分详解

```shell
#无ssl证书、无域名的情况下
# 更改listen端口，由于无域名，无证书需要将各个服务端口区分开
# 若有SSL证书和域名的情况下端口可统一配置443，通过server_name进行区分服务
# 三个服务配置都有80重定向443，根据实际需求开启

operesty-nginx/stream/{operation.conf,portal.conf,openapi-saas.conf}
# server{
#    listen 80;
#    server_name  xxx.xxx.com;
#    rewrite ^(.*)$ https://xxx.xxx.com$1  permanent;
# }


operesty-nginx/stream/operation.conf
server {
  # listen       443 ssl; 
  listen       80;
  # root         html;
#   server_name  xxxx.ops.com;
...


operesty-nginx/stream/portal.conf
server {
  # listen       443 ssl; 
  listen       81;
  # root         html;
#   server_name  xxxx.portal.com;
...

operesty-nginx/stream/openapi-saas.conf
server {
  # listen       443 ssl; 
  listen       82;
  # root         html;
#   server_name  xxxx.api.com;
...

# 更改docker-compose.yml端口映射为
# 如配置SSL和域名则端口映射80  443
# $PWD/operesty-nginx/docker-comopse.yml
...
    ports:
      # - "80:80"
      # - "443:443"
      - "8440:80"
      - "8441:81"
      - "8442:82"
...
```

#### 4.9.3. 启动nginx

```shell
#镜像下载
docker pull openresty/openresty:latest

# 创建docker-compose文件
cat >> docker-compose.yaml <<EOF
version: '3'
services:
  nginx:
    container_name: nginx
    image: openresty/openresty:latest
    restart: always
    volumes:
      - \$PWD/conf/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf
      - \$PWD/conf/ip_white.conf:/usr/local/openresty/nginx/conf/ip_white.conf
      - \$PWD/stream:/etc/nginx/conf.d
      - \$PWD/logs:/var/log/
      - \$PWD/ssl:/etc/nginx/ssl
      - /etc/hosts:/etc/hosts
      - \$PWD/html/operation/dist:/usr/local/openresty/nginx/html/operation
      - \$PWD/html/portal/dist:/usr/local/openresty/nginx/html/portal
    ports:
      #- 8440 运营系统前端，8441门户系统前端，8442算力中心OpenApi
      - "8440:80"
      - "8441:81"
      - "8442:82"
    environment:
        TZ: Asia/Shanghai
EOF


#启动
docker-compose up -d                
```
