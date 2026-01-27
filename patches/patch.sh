#!/bin/bash

src=$1
version=$2
major_ver=$(echo "$version" | cut -d. -f1)
minor_ver=$(echo "$version" | cut -d. -f2)
patch_ver=$(echo "$version" | cut -d. -f3)

echo "patching ..."

# 替换 jdk
if [ "$major_ver" -ge 8 ]; then
    JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
elif [ "$major_ver" -eq 7 ] || ([ "$major_ver" -eq 6 ] && [ "$minor_ver" -ge 7 ]); then
    JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
else
    JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"
fi
cp -rL $JAVA_HOME/. $src/jdk/

# 替换 jruby  jruby从9.3.10.0开始支持loongarch，最早使用该版本的logstash为v8.6.2，
# 故此前的版本均将jruby替换为和v8.6.2一致，尽可能减少差异
if [ "$major_ver" -lt 8 ] || ([ "$major_ver" -eq 8 ] && [ "$minor_ver" -lt 6 ]) ||
  ([ "$major_ver" -eq 8 ] && [ "$minor_ver" -eq 6 ] && [ "$patch_ver" -le 1 ]); then
    jruby_tar=jruby-dist-9.3.10.0-bin.tar.gz
    wget https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.3.10.0/$jruby_tar
    tar -xzf $jruby_tar -C $src/vendor/jruby --strip-components=1
    rm -f $jruby_tar
fi

echo "done"

