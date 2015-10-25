#!/bin/sh
# version 1.1.0

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

# First execution
if [ ! -d "cache" ]
then
    mkdir -p cache/img
    touch cache/manifest_png
    touch cache/manifest_jpg
fi

echo Mimify HTML
for file in $(find prod/ -type f -not -path '*/\.*' -name *.html)
do
    html-minifier --remove-comments --collapse-whitespace --remove-redundant-attributes --case-sensitive -o $file $file
done

echo Mimify CSS
for file in $(find prod/css/ -type f -not -path '*/\.*')
do
    cleancss -o $file $file
done

echo Mimify JS
for file in $(find prod/js/ -type f -not -path '*/\.*')
do
    uglifyjs $file -o $file
done

echo Compress PNG images
if [ "$(find dev/img/ -name *.png | wc -l)" -ne "0" ]
then
    # Remove cached images changed
    md5sum dev/img/*.png | diff cache/manifest_png - | awk '$1 ~ /^</ {print $3}' | sed 's/^dev/cache/' | xargs rm -f

    # Copy new images in cache folder
    for devFilePath in $(md5sum dev/img/*.png | diff cache/manifest_png - | awk '$1 ~ /^>/ {print $3}')
    do
        cacheFilePath=`echo $devFilePath | sed 's/^dev/cache/'`
        cp $devFilePath $cacheFilePath

        echo "Compressing: $cacheFilePath"
        optipng -o7 -strip=all $cacheFilePath
    done

    # Save manifest
    md5sum dev/img/*.png > cache/manifest_png
else
    echo "No PNG files to compress"
fi

echo Compress JPG images
if [ "$(find dev/img/ -name *.jpg | wc -l)" -ne "0" ]
then
    # Remove cached images changed
    md5sum dev/img/*.jpg | diff cache/manifest_jpg - | awk '$1 ~ /^</ {print $3}' | sed 's/^dev/cache/' | xargs rm -f

    # Add cache new images compressed
    for devFilePath in $(md5sum dev/img/*.jpg | diff cache/manifest_jpg - | awk '$1 ~ /^>/ {print $3}')
    do
        cacheFilePath=`echo $devFilePath | sed 's/^dev/cache/'`
        cp $devFilePath $cacheFilePath

        echo "Compressing: $cacheFilePath"
        jpegoptim -m 80 --strip-all $cacheFilePath
    done

    # Save manifest
    md5sum dev/img/*.jpg > cache/manifest_jpg
else
    echo "No JPG files to compress"
fi

# Copy cache images to prod folder
cp -R cache/img/. prod/img

# Gzip all files
for file in $(find prod/ -type f -not -path '*/\.*')
do
    gzip -9 -c $file > $file.gz
done

echo "Compression done"