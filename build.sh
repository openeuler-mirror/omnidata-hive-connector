#!/bin/bash
cd hive-rel-release-3.1.3
cp ../push_down.patch .
patch -p1 < push_down.patch
mvn clean install -Pdist -DskipTests 
