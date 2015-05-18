#!/bin/sh

if [ ! -x /usr/local/bin/cleancss ];
then
    echo You have to install cleancss
    echo Try sudo npm install clean-css -g
    echo More information on https://github.com/jakubpawlowicz/clean-css
    exit
fi

if [ ! -x /usr/local/bin/uglifyjs ];
then
    echo You have to install uglifyjs
	echo Try sudo npm install uglify-js -g
    echo More information on https://github.com/mishoo/UglifyJS2
    exit
fi

if [ ! -x /usr/local/bin/html-minifier ];
then
    echo You have to install html-minifier
	echo Try sudo npm install html-minifier -g
    echo More information on https://github.com/kangax/html-minifier
    exit
fi

if [ ! -x /usr/bin/optipng ] && [ ! -x /usr/local/bin/optipng ];
then
    echo You have to install optipng
    echo Try sudo apt-get install optipng
    echo More information on http://optipng.sourceforge.net
    exit
fi

if [ ! -x /usr/bin/jpegoptim ] && [ ! -x /usr/local/bin/jpegoptim ];
then
    echo You have to install jpegoptim
    echo Try sudo apt-get install jpegoptim
    echo More information on http://www.kokkonen.net/tjko/projects.html
    exit
fi

rm -rf prod
mkdir prod
cp -R dev/. prod

for file in $(find prod/ -type f -not -path '*/\.*' -name *.html)
do
    html-minifier --remove-comments --collapse-whitespace --remove-redundant-attributes --case-sensitive -o $file $file
    gzip -9 -c $file > $file.gz
done

for file in $(find prod/css/ -type f -not -path '*/\.*')
do
	cleancss -o $file $file
	gzip -9 -c $file > $file.gz
done

for file in $(find prod/js/ -type f -not -path '*/\.*')
do
	uglifyjs $file -o $file
	gzip -9 -c $file > $file.gz
done

for file in $(find prod/font/ -type f -not -path '*/\.*')
do
	gzip -9 -c $file > $file.gz
done

for file in $(find prod/img/ -type f -not -path '*/\.*' -name *.png)
do
	optipng -o7 -strip=all $file
	gzip -9 -c $file > $file.gz
done

for file in $(find prod/img/ -type f -not -path '*/\.*' -name *.jpg)
do
	jpegoptim -m 80 --strip-all $file
	gzip -9 -c $file > $file.gz
done
