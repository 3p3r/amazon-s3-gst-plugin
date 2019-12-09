/* amazon-s3-gst-plugin
 * Copyright (C) 2019 Amazon <mkolny@amazon.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
#ifndef __GST_S3_UPLOADER_CONFIG_H__
#define __GST_S3_UPLOADER_CONFIG_H__

#include <glib.h>

#include "gstawscredentials.h"

G_BEGIN_DECLS

#define GST_S3_UPLOADER_CONFIG_DEFAULT_BUFFER_SIZE 5 * 1024 * 1024
#define GST_S3_UPLOADER_CONFIG_DEFAULT_BUFFER_COUNT 4
#define GST_S3_UPLOADER_CONFIG_DEFAULT_INIT_AWS_SDK TRUE
#define GST_S3_UPLOADER_CONFIG_DEFAULT_SPLIT_BUFFERS FALSE
#define GST_S3_UPLOADER_CONFIG_DEFAULT_SPLIT_BUFFERS_WT_DISPOSE_WAIT TRUE
#define GST_S3_UPLOADER_CONFIG_DEFAULT_SPLIT_BUFFERS_WT_EXCLUSIVE TRUE
#define GST_S3_UPLOADER_CONFIG_DEFAULT_SPLIT_BUFFERS_WT_MAX_THREADS 0

typedef struct {
  gchar * region;
  gchar * bucket;
  gchar * key;
  gchar * content_type;
  gchar * ca_file;
  GstAWSCredentials * credentials;
  gsize buffer_size;
  gsize buffer_count;
  gboolean init_aws_sdk;
  gboolean split_buffers;
  gboolean split_buffers_worker_thread_dispose_wait;
  gboolean split_buffers_worker_thread_exclusive;
  gint split_buffers_worker_thread_max_threads;
} GstS3UploaderConfig;

#define GST_S3_UPLOADER_CONFIG_INIT (GstS3UploaderConfig) { \
  NULL, NULL, NULL, NULL, NULL, NULL, \
  GST_S3_UPLOADER_CONFIG_DEFAULT_BUFFER_SIZE, \
  GST_S3_UPLOADER_CONFIG_DEFAULT_BUFFER_COUNT, \
  GST_S3_UPLOADER_CONFIG_DEFAULT_INIT_AWS_SDK, \
  GST_S3_UPLOADER_CONFIG_DEFAULT_SPLIT_BUFFERS, \
  GST_S3_UPLOADER_CONFIG_DEFAULT_SPLIT_BUFFERS_WT_DISPOSE_WAIT, \
  GST_S3_UPLOADER_CONFIG_DEFAULT_SPLIT_BUFFERS_WT_EXCLUSIVE, \
  GST_S3_UPLOADER_CONFIG_DEFAULT_SPLIT_BUFFERS_WT_MAX_THREADS \
}

G_END_DECLS

#endif /* __GST_S3_UPLOADER_CONFIG_H__ */
