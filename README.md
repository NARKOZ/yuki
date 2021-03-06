# Yuki

Web app for [Gifzo](http://gifzo.net/).

![Screen Shot](https://raw.githubusercontent.com/NARKOZ/yuki/gh-pages/screenshot.png)

## Requirements

+ SQLite 3
+ Ruby 1.9.3 or upper

Optional:
+ Mac OS (for Gifzo.app)
+ FFmpeg (for creating gif images)

## Installation

```sh
git clone https://github.com/NARKOZ/yuki.git
cd yuki
bundle install
```

## Usage

1. Run Yuki:

  ```sh
  rackup -p 9000
  ```

2. Install Gifzo from website: http://gifzo.net
3. Set upload URL point to Yuki:

  ```sh
  defaults write net.gifzo.Gifzo url -string "http://localhost:9000/"
  ```

## Resources

+ [Gifzo.app](https://github.com/cockscomb/Gifzo.app)
+ [Pyazo2](https://github.com/uzulla/Pyazo2)
