# typed: false

require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "tmp/uploads/cache"), # temporary
  store: Shrine::Storage::S3.new(
    # host: " http://172.17.0.2",
    bucket: ENV.fetch("S3_BUCKET"), # required
    region: "eu-west-1", # required
    access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
    secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY")
  )       # permanent
}

# Shrine.plugin :url_options, store: { host: "http://abc123.cloudfront.net" }
Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
