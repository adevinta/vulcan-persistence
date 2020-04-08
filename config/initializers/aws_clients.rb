require 'aws-sdk-rails'

region = ENV['REGION'] || ""
s3_endpoint = ENV['AWS_S3_ENDPOINT'] || ""
sns_endpoint = ENV['AWS_SNS_ENDPOINT'] || ""
sqs_endpoint = ENV['AWS_SQS_ENDPOINT'] || ""

if region != ""
  Aws.config.update({
    region: region,
  })
end

fake_credentials = Aws::Credentials.new('fake_access_key', 'fake_secret_key')

if ENV['RAILS_ENV'] == "test"
  WebMock.disable_net_connect!(allow_localhost: true)
  # SQS Client
  Rails.application.config.sqs_client = Aws::SQS::Client.new(
    stub_responses: true,
  )
  Rails.application.config.sqs_client.stub_responses(
    :get_queue_url, { queue_url: 'http://localhost/dummy' },
  )
  Rails.application.config.sqs_client.stub_responses(
    :send_message, { message_id: "fake_message_id" },
  )
  # SNS Client
  Rails.application.config.sns_client = Aws::SNS::Client.new(
    stub_responses: true,
  )
  Rails.application.config.sns_client.stub_responses(
    :publish, {},
  )
  # S3 Client
  Rails.application.config.s3_client = Aws::S3::Client.new(
    stub_responses: true,
  )
# Not testing, create not mocked clients.
else
  # SQS Client
  if sqs_endpoint != ""
    Rails.application.config.sqs_client = Aws::SQS::Client.new(
      :endpoint => sqs_endpoint,
      :credentials => fake_credentials,
      :log_level => "debug",
    )
  else
    Rails.application.config.sqs_client = Aws::SQS::Client.new()
  end
  # SNS Client
  if sns_endpoint != ""
    Rails.application.config.sns_client = Aws::SNS::Client.new(
      :endpoint => sns_endpoint,
      :credentials => fake_credentials,
      :log_level => "debug",
    )
  else
    Rails.application.config.sns_client = Aws::SNS::Client.new()
  end
  # S3 Client
  if s3_endpoint != ""
    Rails.application.config.s3_client = Aws::S3::Client.new(
      :endpoint => s3_endpoint,
      :credentials => fake_credentials,
      :log_level => "debug",
    )
  else
    Rails.application.config.s3_client = Aws::S3::Client.new()
  end
end
