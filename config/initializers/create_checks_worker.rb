#Create the workers that read from the queue and create checks.
sqs_create_checks_url = ENV['AWS_CREATE_CHECKS_SQS_URL'] || ''
create_checks_nof_workers = 0
nchecks = ENV['AWS_CREATE_CHECKS_WORKERS'] || '0'
begin
  create_checks_nof_workers = Integer(nchecks)
rescue StandardError
  Rails.logger.error("error invalid AWS_CREATE_CHECKS_WORKERS value #{nchecks}")
end

Rails.logger.info("initializing #{create_checks_nof_workers} check creation workers")

while create_checks_nof_workers.positive?
  Rails.application.config.after_initialize do
    CreateChecksJob.perform_later(sqs_create_checks_url)
  end
  create_checks_nof_workers -= 1
end
