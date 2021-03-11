# Copyright 2021 Adevinta

require 'securerandom'

class Filescan
  @@s3_bucket =  Aws::S3::Resource.new(client: Rails.application.config.s3_client).bucket(Rails.application.config.scans_bucket)
  @@s3_service = S3Service.new(@@s3_bucket)
  def self.save_scan(id, params)
    name = id.to_s + ".json"
    @@s3_service.upload(params['upload'], name)
  end
  # This is needed in to avoid the model to be persited to db by rails.
  def persisted?
    false
  end

end
