require 'aws-sdk-s3'

# 環境変数の設定
ENV['R2_ACCESS_KEY_ID'] = 'b1da5c2ccb287a98f7c09e19906b986b'
ENV['R2_SECRET_ACCESS_KEY'] = '95a945393d0b983b7f97f98044fcc12c0b7789529c0b543f8b7ea273fa1839ab'
ENV['R2_REGION'] = 'auto'
ENV['R2_BUCKET_NAME'] = 'avatar-uploads'
ENV['R2_ENDPOINT'] = 'https://e66eb17ebd9992a12d61e2af05da72ce.r2.cloudflarestorage.com'

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

  def generate_signed_url(file_key, expires_in = 3600)
    signer = Aws::S3::Presigner.new(client: @client)
    signed_url = signer.presigned_url(:get_object, bucket: @bucket, key: file_key, expires_in: expires_in)
    puts "Generated signed URL: #{signed_url}"
    signed_url
  end
end

# サービスのインスタンス化
service = CloudflareR2Service.new


# 署名付きURLの生成
file_key = 'avatars/60fefaa4-c327-43dc-a9c7-ea8547a2deb7/%E3%83%92%E3%82%9A%E3%82%AF%E3%83%9F%E3%83%B3.jpeg'
signed_url = service.generate_signed_url(file_key)
puts "署名付きURL: #{signed_url}"
