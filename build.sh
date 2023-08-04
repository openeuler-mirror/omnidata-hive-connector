#!/bin/bash
wget https://github.com/apache/hive/archive/refs/tags/rel/release-3.1.3.tar.gz --no-check-certificate
tar -zxvf release-3.1.3.tar.gz
cd hive-rel-release-3.1.3
cp ../push_down.patch .
patch -p1 < push_down.patch
mvn clean install -Pdist -DskipTests 
