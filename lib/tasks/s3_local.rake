# typed: false

namespace :s3 do
  task :local do
    s3_port = ENV.fetch("S3_PORT", 8333)
    aws_access_key_id = ENV.fetch("AWS_ACCESS_KEY_ID", "admin")
    aws_secret_access_key = ENV.fetch("AWS_SECRET_ACCESS_KEY", "secret")
    s3_bucket = ENV.fetch("S3_BUCKET", "my-bucket")

    sh "docker run -p 8333:#{s3_port} \
      -e AWS_ACCESS_KEY_ID=#{aws_access_key_id} \
      -e AWS_SECRET_ACCESS_KEY=#{aws_secret_access_key} \
      -e S3_BUCKET=#{s3_bucket} \
      -v $(pwd)/tmp/s3_local_data:/data \
      --name s3_local_seaweed \
      chrislusf/seaweedfs"
  end
end
