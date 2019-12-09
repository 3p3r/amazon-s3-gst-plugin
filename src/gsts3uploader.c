#include "gsts3uploader.h"
#include "gsts3multipartuploader.h"

#define GET_CLASS_(uploader) ((GstS3Uploader*) (uploader))->klass
// https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html
// max filename size is 1024 bytes on S3
#define S3_MAX_FILENAME_SIZE 1024

void
gst_s3_uploader_destroy (GstS3Uploader * uploader)
{
  GET_CLASS_ (uploader)->destroy (uploader);
}

gboolean
gst_s3_uploader_upload_part (GstS3Uploader * uploader,
    const gchar * buffer, gsize size)
{
  return GET_CLASS_ (uploader)->upload_part (uploader, buffer, size);
}

gboolean
gst_s3_uploader_complete (GstS3Uploader * uploader)
{
  return GET_CLASS_ (uploader)->complete (uploader);
}

gboolean
gst_s3_upload(const GstS3UploaderConfig * config,
    const void * buffer, gsize size)
{
  gchar upload_key[S3_MAX_FILENAME_SIZE];
  GstS3UploaderConfig *config_shallow_copy = (GstS3UploaderConfig *) config;
  g_snprintf(upload_key, S3_MAX_FILENAME_SIZE, config->key, g_get_real_time());
  config_shallow_copy->key = upload_key;

  GstS3Uploader *uploader = gst_s3_multipart_uploader_new(config_shallow_copy);
  g_assert_nonnull(uploader);

  gboolean ret =  gst_s3_uploader_upload_part(uploader, (const char *)buffer, size) &&
                  gst_s3_uploader_complete(uploader);

  gst_s3_uploader_destroy(uploader);
  return ret;
}
