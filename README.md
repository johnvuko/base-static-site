# Base scaffold for static web development

This code is a scaffold for landing page. It minify your code, optimize your images and create a gzip version of every files.

The goal is to optimize the size and the speed of the website at the maximum.

## Requirements

You need to have the followings package installed:
- [npm](https://www.npmjs.com/) Package manager for [NodeJS](https://nodejs.org)
- [clean-css](https://github.com/jakubpawlowicz/clean-css) Minify your CSS
- [UglifyJS 2](https://github.com/mishoo/UglifyJS2) Minify your Javascript
- [html-minifier](https://github.com/kangax/html-minifier) Minify your HTML
- [optipng](http://optipng.sourceforge.net) Compress your PNG images (version 0.7 minimum)
- [jpegoptim](http://www.kokkonen.net/tjko/projects.html) Compress your JPEG images

## Installing Dependencies

- `npm` is installed with `NodeJS`, [check NodeJS documentation for more details](https://nodejs.org/download/)

- `clean-css`, `UglifyJS 2` and `html-minifier` are npm packages:
```shell
    sudo npm install clean-css -g
    sudo npm install uglify-js -g
    sudo npm install html-minifier -g
```

- `optipng` can be installed with:
```shell
    sudo apt-get install optipng
```
Check the version of `optipng` with `optipng -v` if it's inferior to 0.7, you have to download optipng at http://optipng.sourceforge.net/

- `jpegoptim` can be installed with:
```shell
    sudo apt-get install jpegoptim
```

## Usage

Once you have everything is installed, you have to copy the repository:
```shell
curl -L -O https://github.com/jonathantribouharet/base-static-site/archive/master.zip && unzip master && rm master.zip && mv base-static-site-master site
```
This command download the latest version, unzip it in `site` folder and remove the downloaded archive.

Compress and minify your code with:
```shell
./compress.sh
```
The command generate a `prod` folder containg your project fully optimized.

### What's in it?

- `dev` folder, it's your working folder, every pages must be in it with `.html` extension. By default you have an `index.html` file with the minimum.
- `dev/css`, every css files must be in it with `.css` extension. By default you have a `reset.css` and an empty file `style.css`.
- `dev/img`, every images must be in it with `.png` or `.jpg` extension.
- `dev/js`, every javascript files must be in it with `.js`.
- `dev/font`, used for fonts but no particular process are applied to this folder.
- `compress.sh`, the script you have to run for create the `prod` folder with every files minified and compressed.

### How it works

When you run `compress.sh` by doing
```shell
./compress.sh
```

- it create a new folder `prod` (remove the older one if exist)
- copy the HTML, Javascript, CSS and fonts files from `dev` to `prod`
- minify your HTML, Javascript and CSS files
- optimize your images files
- create a `gzip` version of every files. It avoid the server to do it dynamically and we use a the biggest compression existing. If you use [nginx](http://nginx.org/), check the [gzip_static](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html) option, activate with `gzip_static on;`

## Author

- [Jonathan Tribouharet](https://github.com/jonathantribouharet) ([@johntribouharet](https://twitter.com/johntribouharet))

## License

This code is released under the MIT license. See the LICENSE file for more info.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/jonathantribouharet/base-static-site/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

