require 'aws-sdk-s3'
require 'securerandom'
require 'logger'

class CloudflareR2Service
  def initialize
    # 環境変数を直接コード内に埋め込む
    access_key_id = 'b1da5c2ccb287a98f7c09e19906b986b'
    secret_access_key = '95a945393d0b983b7f97f98044fcc12c0b7789529c0b543f8b7ea273fa1839ab'
    region = 'us-east-1'
    endpoint = 'https://e66eb17ebd9992a12d61e2af05da72ce.r2.cloudflarestorage.com'
    bucket_name = 'avatar-uploads'

    @client = Aws::S3::Client.new(
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      region: region,
      endpoint: endpoint,
      logger: Logger.new($stdout),
      log_level: :debug
    )
    @bucket = bucket_name
  end

  def upload(file_path, file_name)
    file_key = "avatars/#{SecureRandom.uuid}/#{file_name}"
    @client.put_object(
      bucket: @bucket,
      key: file_key,
      body: File.read(file_path),
      acl: 'public-read'
    )
    puts "Uploaded file to: #{file_key}"
    "#{@client.config.endpoint}/#{@bucket}/#{file_key}"
  end

  def generate_signed_url(file_key, expires_in = 600)
    begin
      signer = Aws::S3::Presigner.new(client: @client)
      signed_url = signer.presigned_url(:get_object, bucket: @bucket, key: file_key, expires_in: expires_in)
      puts "Generated signed URL: #{signed_url}"
      signed_url
    rescue Aws::S3::Errors::ServiceError => e
      puts "Error generating signed URL: #{e.message}"
      nil
    end
  end
end

# サービスのインスタンス化
service = CloudflareR2Service.new

# 既存のファイルキーを使用して署名付きURLを生成
file_key = 'avatars/5909f7e7-f02a-43c7-aa27-e4939bfe4c6b/Revision.png'
signed_url = service.generate_signed_url(file_key)
puts "署名付きURL: #{signed_url}"

# 署名付きURLを使用してファイルをダウンロード
system("curl -o downloaded_image.png \"#{signed_url}\"")