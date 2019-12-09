cmake_minimum_required(VERSION 3.2)

project(amazon-s3-gst-plugin)

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

find_package(AWSSDK REQUIRED COMPONENTS s3 sts)
find_package(GStreamer REQUIRED COMPONENTS base check)
find_package(GLIB REQUIRED COMPONENTS gobject)
find_package(Threads REQUIRED)
find_package(Orc REQUIRED)

add_compile_options(-m64 -DHAVE_ORC=1)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src
                    ${CMAKE_CURRENT_BINARY_DIR}
                    ${GSTREAMER_CHECK_INCLUDE_DIRS}
                    ${GSTREAMER_BASE_INCLUDE_DIRS}
                    ${GSTREAMER_INCLUDE_DIRS}
                    ${ORC_INCLUDE_DIRS}
                    ${GLIB_INCLUDE_DIRS}
                    ${AWSSDK_INCLUDE_DIRS})

link_libraries(${GLIB_LIBRARIES}
               ${GLIB_GOBJECT_LIBRARIES}
               ${ORC_LIBRARIES}
               ${GSTREAMER_LIBRARIES}
               ${GSTREAMER_BASE_LIBRARIES}
               ${GSTREAMER_CHECK_LIBRARIES}
               ${AWSSDK_LINK_LIBRARIES})

set(PLUGIN_PACKAGE "amazon-s3-gst-plugin")
set(PLUGIN_VERSION "0.1.0")
configure_file(src/config.h.in config.h @ONLY)

add_library(s3sink SHARED
            src/gstawscredentials.cpp
            src/gstawscredentials.h
            src/gstawscredentials.hpp
            src/gsts3elements.c
            src/gsts3multipartuploader.cpp
            src/gsts3multipartuploader.h
            src/gsts3sink.c
            src/gsts3sink.h
            src/gsts3uploader.c
            src/gsts3uploaderconfig.h
            src/gsts3uploader.h)

target_link_libraries(s3sink)

enable_testing()
add_executable(s3sink-check tests/check/s3sink.c)
target_link_libraries(s3sink-check s3sink)
add_test(s3sink-test s3sink-check)
