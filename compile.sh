#!/bin/sh

if ! mvn --version > /dev/null; then
    echo Cannot find mvn
    echo Please install maven from https://maven.apache.org/download.cgi
    echo Alternatively use \"sudo apt-get install maven\"
    echo Or \"brew install maven\"
    exit 1
fi

if ! ant -version > /dev/null; then
    echo Cannot find ant
    echo Please install ant from http://ant.apache.org/manual-1.9.x/install.html
    echo Alternatively use \"sudo apt-get install ant\"
    echo Or \"brew install ant\"
    exit 1
fi

dependencies="googlei18n/libphonenumber google/closure-library google/closure-compiler google/closure-linter google/python-gflags"

for dependency in $dependencies; do
    echo 'Checking dependency '$dependency
    dir='../'`echo $dependency | cut -d '/' -f 2`
    if [ -d $dir ]; then
        cd $dir > /dev/null
        git pull
        cd - > /dev/null
    else
        git clone https://github.com/$dependency $dir --depth 1
    fi
done

cd ../closure-compiler; mvn -DskipTests -pl externs/pom.xml,pom-main.xml,pom-main-shaded.xml -X; cd -

ant -f build.xml compile
