cmake_minimum_required(VERSION 3.2)

project(amazon-s3-gst-plugin)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
  message(
    STATUS
      "Building for release, use -DCMAKE_BUILD_TYPE=Debug to build for debugging."
    )
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/tools/share/cmake)

set(BUILD_SHARED_LIBS ON)
find_package(AWSSDK REQUIRED COMPONENTS s3 sts)

find_package(GStreamer REQUIRED COMPONENTS base check video)
find_package(GLIB REQUIRED COMPONENTS gobject)
find_package(Threads REQUIRED)
find_package(Orc REQUIRED)

add_compile_options(-m64 -DHAVE_ORC=1)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src
                    ${CMAKE_CURRENT_BINARY_DIR}
                    ${GSTREAMER_VIDEO_INCLUDE_DIRS}
                    ${GSTREAMER_CHECK_INCLUDE_DIRS}
                    ${GSTREAMER_BASE_INCLUDE_DIRS}
                    ${GSTREAMER_INCLUDE_DIRS}
                    ${ORC_INCLUDE_DIRS}
                    ${GLIB_INCLUDE_DIRS}
                    ${AWSSDK_INCLUDE_DIRS})

link_libraries(Threads::Threads
               ${GLIB_LIBRARIES}
               ${GLIB_GOBJECT_LIBRARIES}
               ${ORC_LIBRARIES}
               ${GSTREAMER_LIBRARIES}
               ${GSTREAMER_BASE_LIBRARIES}
               ${GSTREAMER_CHECK_LIBRARIES}
               ${GSTREAMER_VIDEO_LIBRARIES}
               ${AWSSDK_LINK_LIBRARIES})

set(PLUGIN_PACKAGE "amazon-s3-gst-plugin")
set(PLUGIN_VERSION "0.1.0")
configure_file(src/config.h.in config.h @ONLY)

add_library(gsts3elements SHARED
            src/gsts3elements.c
            src/gsts3sink.c
            src/gsts3uploader.c
            src/gstsplitmuxsink.c
            src/gsts3multipartuploader.cpp
            src/gstawscredentials.cpp)

enable_testing()
add_executable(gsts3elements-check tests/check/s3sink.c)
target_link_libraries(gsts3elements-check gsts3elements)
add_test(gsts3elements-test gsts3elements-check)

set_tests_properties(
  gsts3elements-test
  PROPERTIES ENVIRONMENT
             LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}:$ENV{LD_LIBRARY_PATH}
             ENVIRONMENT
             GST_PLUGIN_PATH=${CMAKE_BINARY_DIR})
