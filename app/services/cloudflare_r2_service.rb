require 'aws-sdk-s3'
require 'securerandom'
require 'logger'
require 'dotenv/load'

class CloudflareR2Service
  def initialize
    access_key_id = 'b1da5c2ccb287a98f7c09e19906b986b'
    secret_access_key = '95a945393d0b983b7f97f98044fcc12c0b7789529c0b543f8b7ea273fa1839ab'
    region = 'us-east-1'
    endpoint = 'https://e66eb17ebd9992a12d61e2af05da72ce.r2.cloudflarestorage.com'
    bucket_name = 'avatar-uploads'
    public_base_url = 'https://pub-cdd6c65fb56640409296f93234e9fc38.r2.dev'

    @client = Aws::S3::Client.new(
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      region: region,
      endpoint: endpoint,
      logger: Logger.new($stdout),
      log_level: :debug,
      credentials: Aws::Credentials.new(access_key_id, secret_access_key)
    )
    @bucket = bucket_name
    @public_base_url = public_base_url
  end

  def upload(file_path, file_name)
    file_key = "avatars/#{SecureRandom.uuid}/#{file_name}"
    @client.put_object(
      bucket: @bucket,
      key: file_key,
      body: File.read(file_path),
      acl: 'public-read'
    )
    "#{@public_base_url}/#{file_key}"
  end
end
