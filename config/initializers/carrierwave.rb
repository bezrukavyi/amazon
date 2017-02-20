CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'

  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Figaro.env.aws_access_key_id,
    aws_secret_access_key: Figaro.env.aws_secret_access_key,
    region: 'eu-west-1',
    host: Figaro.env.domain_name
  }
  config.fog_directory  = 'directory'
  config.fog_public     = false
  config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
end
