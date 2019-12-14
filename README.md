## Amazon S3 Gst Plugin+

**NOTE:** This is a fork of the original repository and it's tested solely for Linux 64bit. Changelog:

- Replaced Meson with CMake
- Added VSCode settings for easier debugging
- Removed the `init-aws-sdk` property from the sink (it's handled automatically internally now)
- Added a slightly modified version of the `splitmuxsink` plugin that works with this version of `s3sink`
- Renamed the `key` property to `location` so `s3sink` can work with `splitmuxsink`

A collection of [GStreamer](https://gstreamer.freedesktop.org/) elements to interact
with the [Amazon Simple Storage Service (S3)](https://aws.amazon.com/s3/).

### Building the project

For build dependencies, take a look at the upstream repository.

```bash
$ mkdir build
$ cd build
$ cmake ..
$ make -j 4
$ make test
```

After executing commands above, the plugin (`libgsts3elements.so`) should be installed in the default GStreamer's plugin path. It can also be found in the build directory, and used by specifying the plugin path:

```bash
$ GST_PLUGIN_PATH=build gst-inspect-1.0 s3sink
$ GST_PLUGIN_PATH=build gst-inspect-1.0 s3splitmuxsink
```

### Sample usage with `s3splitmuxsink`:

```
$ export BUCKET=<your bucket name>
$ gst-launch-1.0 -e -vv videotestsrc is-live=true do-timestamp=true ! video/x-raw,format=I420,width=1920,height=1080 ! videorate ! video/x-raw,framerate=30/1 ! videoconvert ! jpegenc ! s3splitmuxsink sink-factory=s3sink sink-properties="properties,bucket=$BUCKET" muxer-factory=avimux muxer-properties="properties,bigfile=true" max-size-time=10000000000 location=gst/upload-%d.avi async-finalize=true
```
