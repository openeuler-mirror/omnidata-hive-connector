# omnidata-hive-connector

#### 介绍
大数据OmniData算子下推特性适用于大量计算节点读取远端节点数据的大数据存算分离场景或大规模融合场景。这类场景下，大量原始数据从存储节点通过网络传输到计算节点进行处理，有效数据占比低，极大浪费网络带宽。
大数据OmniData算子下推特性：
1. 实现将计算节点的Filter、Aggregation、Limit算子下推到存储节点进行计算，将算子处理完后的结果通过网络传输到计算节点，降低网络传输数据量，提升Hive、Spark和openLooKeng计算性能。
2. 实现对接同构加速框架（Homogeneous Acceleration Framework，HAF），替换原有GRPC通信下推框架的server/client接口，通过注解形式实现下推。
3. 实现将算子下推到Ceph/HDFS存储节点上处理。

#### 软件架构
1. OmniData Client属于开源的部分，为不同的引擎提供相应的插件。通过HAF提供的注解和编译插件，在需要下推的函数上添加注解，HAF会自动把任务下推到卸载节点的OmniData Server中，让用户感觉好像在本地执行一样。
2. 这里是列表文本Host Runtime为lib库，部署在计算节点（主机节点），对外提供任务卸载的能力，把任务下推到Target Runtime。Target Runtime为lib库，部署在存储节点（卸载节点），提供任务执行的能力，用来执行OmniData Server的作业。
3. OmniData Server提供算子下推（算子卸载）的执行能力，接收Host Runtime下推下来的任务。


#### 安装教程
### 1. omnidata-hive-connect
### 1.1. 脚本编译
    执行build.sh脚本，完成编译后在源码下的“packaging/target”目录生成Hive的tar.gz包
### 1.2. 手动编译
### 1.2.1. 下载源码包
    wget https://github.com/apache/hive/archive/refs/tags/rel/release-3.1.3.tar.gz --no-check-certificate
### 1.2.2. 解压源码包
    tar -zxvf release-3.1.3.tar.gz
### 1.2.3. 打入patch
    cd hive-rel-release-3.1.3
    cp ../push_down.patch .
    patch -p1 < push_down.patch
### 1.2.4. 编译
    mvn clean install -Pdist -DskipTests 
完成编译后在源码下的“packaging/target”目录生成Hive的tar.gz包
### 2.  hive安装(必须部署tez)
按照部署文档部署tez和hive，参考文档 > https://www.hikunpeng.com/document/detail/zh/kunpengbds/ecosystemEnable/Hive/kunpenghive_04_0019.html

#### 使用说明
运行时需要依赖omnidata,需要部署omnidata，运行时加载配置文件
1. 部署omnidata
部署文档> https://www.hikunpeng.com/document/detail/zh/kunpengboostkithistory/2200/bds/kunpengomnidata_20_0037.html
2. tez添加配置项

```
<property>
    <name>tez.user.classpath.first</name>
    <value>true</value>
</property>
<property>
    <name>tez.task.launch.env</name>
    <value>PATH=/home/omm/omnidata-install/haf-host/bin:$PATH,LD_LIBRARY_PATH=/home/omm/omnidata-install/haf-host/lib:$LD_LIBRARY_PATH,CLASS_PATH=/home/omm/omnidata-install/haf-host/lib/jar/haf-1.3.0.jar:$CLASS_PATH,HAF_CONFIG_PATH=/home/omm/omnidata-install/haf-host/etc/</value>
    </property>
```




注：/home/omm/omnidata-install为示例路径，用户需修改为第一步实际的部署目录。

3. tez添加依赖包

用户将从> https://gitee.com/kunpengcompute/boostkit-bigdata/releases/download/v1.4.0/boostkit-omnidata-hive-exec-3.1.0-1.4.0.zip
下载到的jar、omnidata-client、omnidata-common、haf包添加到tez/lib 目录下，后打包上传到hdfs

4. 执行hive引擎时添加运行参数


```
set hive.execution.engine=tez;
set hive.mapjoin.hybridgrace.hashtable=false;
set hive.vectorized.execution.mapjoin.native.fast.hashtable.enabled=true;
set omnidata.hive.enabled=true;
set omnidata.hive.filter.selectivity.enabled=false;
set omnidata.hive.filter.selectivity=0.5;
set omnidata.hive.table.size.threshold=10240;
set omnidata.hive.zookeeper.quorum.server=agent1:2181,agent2:2181,agent3:2181;
set omnidata.hive.zookeeper.status.node=/sdi/status;
set omnidata.hive.zookeeper.conf.path=/usr/local/zookeeper/conf;
```


参数含义可参看文档 > https://www.hikunpeng.com/document/detail/zh/kunpengboostkithistory/2200/bds/kunpengomnidata_20_0122.html
#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
