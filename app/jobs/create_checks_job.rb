class CreateChecksJob < ActiveJob::Base
  def perform(queue_url)
    poller = Aws::SQS::QueuePoller.new(queue_url)
    Rails.logger.info('polling messages')
    poller.poll(skip_delete: true, max_number_of_messages: 10) do |messages|
      messages.each do |msg|
        begin
          create_check = extract_check_params(msg)
          Rails.logger.debug("check to create #{create_check}")
          # If this function does not return a value if the message was not
          # properly formated so we delete it from the queue.
          if create_check
            create_check.permit!
            check = ChecksHelper.create_check(create_check)
            ChecksEnqueueJob.perform_now([check], check.created_at.to_s) if check
          end
        rescue StandardError => e
          Rails.logger.error("Error: #{e.message}, stack trace: #{e.backtrace_locations.inspect}")
        else
          Rails.logger.debug('message processed')
          poller.delete_messages([msg])
        end
      end
    end
    Rails.logger.info('checks creator finished')
  end

  def extract_check_params(msg)
    begin
      body = JSON.parse(msg.body)
      payload = JSON.parse(body['Message'])
      check_params = ActionController::Parameters.new(payload)
      check = check_params[:check]
    rescue StandardError => e
      Rails.logger.error("error bad format for create check message #{msg.inspect}, error: #{e.me}")
    end
    check
  end
end
