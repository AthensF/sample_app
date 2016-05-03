if Rails.env.production?
    CarrierWave.configure do |config|
        config.fog_credentials = {
            #config for amazon S3
            :provider       => 'AWS',
            :aws_access_key_id  => ENV['AKIAICTWG6DY2XSGCELQ'],
            :aws_secret_access_key  => ENV['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']
        }
        config.fog_directory        = ENV['momo98-rails-tutorial']
    end
end
