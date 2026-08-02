# typed: false

require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"

s3 = Shrine::Storage::S3.new(
  bucket: ENV.fetch("S3_BUCKET"), # required
  region: "eu-west-1", # required

  endpoint: "#{ENV.fetch("S3_HOST")}:#{ENV.fetch("S3_PORT")}",
  force_path_style: true,

  access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
  secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY")
)

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("tmp", prefix: "cache/uploads"), # temporary. change to "public" for forms
  store: s3 # permanent
}

Shrine.plugin :activerecord           # loads Active Record integration
