# app/services/cloudflare_r2_service.rb

require 'aws-sdk-s3'

class CloudflareR2Service
  def initialize
    @client = Aws::S3::Client.new(
      access_key_id: ENV['R2_ACCESS_KEY_ID'],
      secret_access_key: ENV['R2_SECRET_ACCESS_KEY'],
      region: ENV['R2_REGION'],
      endpoint: ENV['R2_ENDPOINT']
    )
    @bucket = ENV['R2_BUCKET_NAME']
  end

  def upload(file)
    file_key = "avatars/#{SecureRandom.uuid}/#{file.original_filename}"
    @client.put_object(
      bucket: @bucket,
      key: file_key,
      body: file.tempfile,
      acl: 'public-read'
    )
    "#{@client.config.endpoint}/#{@bucket}/#{file_key}"
  end
end
