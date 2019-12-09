# - Try to find GStreamer and its plugins
# Once done, this will define
#
#  GSTREAMER_FOUND - system has GStreamer
#  GSTREAMER_INCLUDE_DIRS - the GStreamer include directories
#  GSTREAMER_LIBRARIES - link these to use GStreamer
#
# Additionally, gstreamer-base is always looked for and required, and
# the following related variables are defined:
#
#  GSTREAMER_BASE_INCLUDE_DIRS - gstreamer-base's include directory
#  GSTREAMER_BASE_LIBRARIES - link to these to use gstreamer-base
#
# Optionally, the COMPONENTS keyword can be passed to find_package()
# and GStreamer plugins can be looked for.  Currently, the following
# plugins can be searched, and they define the following variables if
# found:
#
#  gstreamer-app:        GSTREAMER_APP_INCLUDE_DIRS and GSTREAMER_APP_LIBRARIES
#  gstreamer-audio:      GSTREAMER_AUDIO_INCLUDE_DIRS and GSTREAMER_AUDIO_LIBRARIES
#  gstreamer-pbutils:    GSTREAMER_PBUTILS_INCLUDE_DIRS and GSTREAMER_PBUTILS_LIBRARIES
#  gstreamer-video:      GSTREAMER_VIDEO_INCLUDE_DIRS and GSTREAMER_VIDEO_LIBRARIES
#
# Copyright (C) 2012 Raphael Kubo da Costa <rakuco@webkit.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1.  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# 2.  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND ITS CONTRIBUTORS ``AS
# IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR ITS
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Copied and adopted from:
# https://github.com/WebPlatformForEmbedded/WPEWebKit/blob/master/Source/cmake/FindGStreamer.cmake

FIND_PACKAGE(PkgConfig)

IF(NOT GStreamer_FIND_VERSION)
  SET(GStreamer_FIND_VERSION "1.14")
ENDIF()

# Helper macro to find a GStreamer plugin (or GStreamer itself)
#   _component_prefix is prepended to the _INCLUDE_DIRS and _LIBRARIES variables (eg. "GSTREAMER_AUDIO")
#   _pkgconfig_name is the component's pkg-config name (eg. "gstreamer-1.0", or "gstreamer-video-1.0").
#   _library is the component's library name (eg. "gstreamer-1.0" or "gstvideo-1.0")
MACRO(FIND_GSTREAMER_COMPONENT _component_prefix _pkgconfig_name _library)

  STRING(REGEX MATCH "(.*)>=(.*)" _dummy "${_pkgconfig_name}")
  IF ("${CMAKE_MATCH_2}" STREQUAL "")
    PKG_CHECK_MODULES(PC_${_component_prefix} "${_pkgconfig_name} >= ${GStreamer_FIND_VERSION}")
  ELSE ()
    PKG_CHECK_MODULES(PC_${_component_prefix} ${_pkgconfig_name})
  ENDIF ()
  SET(${_component_prefix}_INCLUDE_DIRS ${PC_${_component_prefix}_INCLUDE_DIRS})

  FIND_LIBRARY(${_component_prefix}_LIBRARIES
      NAMES ${_library}
      HINTS ${PC_${_component_prefix}_LIBRARY_DIRS} ${PC_${_component_prefix}_LIBDIR}
      )
ENDMACRO()

# ------------------------
# Find GStreamer itself
# ------------------------

FIND_GSTREAMER_COMPONENT(GSTREAMER gstreamer-1.0 gstreamer-1.0)
FIND_GSTREAMER_COMPONENT(GSTREAMER_BASE gstreamer-base-1.0 gstbase-1.0)

# ------------------------------------------------
# Process the COMPONENTS passed to FIND_PACKAGE
# ------------------------------------------------
SET(_GSTREAMER_REQUIRED_VARS
    GSTREAMER_INCLUDE_DIRS
    GSTREAMER_LIBRARIES
    GSTREAMER_VERSION
    GSTREAMER_BASE_INCLUDE_DIRS
    GSTREAMER_BASE_LIBRARIES)

FOREACH (_component ${GStreamer_FIND_COMPONENTS})
  STRING(TOUPPER ${_component} _UPPER_NAME)
  STRING(TOLOWER ${_component} _LOWER_NAME)
  FIND_GSTREAMER_COMPONENT(GSTREAMER_${_UPPER_NAME} gstreamer-${_LOWER_NAME}-1.0 gst${_LOWER_NAME}-1.0)
  IF (Gstreamer_FIND_REQUIRED_${_component})
    LIST(APPEND _GSTREAMER_REQUIRED_VARS GSTREAMER_${_UPPER_NAME}_INCLUDE_DIRS GSTREAMER_${_UPPER_NAME}_LIBRARIES)
  ENDIF ()
ENDFOREACH ()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GStreamer REQUIRED_VARS _GSTREAMER_REQUIRED_VARS
    VERSION_VAR GSTREAMER_VERSION)
