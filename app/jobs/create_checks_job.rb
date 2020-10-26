class CreateChecksJob < ActiveJob::Base
  def perform(queue_url)
    poller = Aws::SQS::QueuePoller.new(queue_url)
    Rails.logger.info('polling messages')
    poller.poll(skip_delete: true, max_number_of_messages: 10) do |messages|
      messages.each do |msg|
        begin
          create_check = extractCheckParams(msg)
          next if !create_check
          check = ChecksHelper.create_check_with_id(check_params[:check])
        rescue StandardError => e
          Rails.logger.error("Error: #{e.message}, stack trace: #{e.backtrace_locations.inspect}")
        else
          Rails.logger.info('message processed')
          poller.delete_messages([msg])
        end
      end
    end
    Rails.logger.info('checks creator finished')
  end

  def extractCheckParams(msg)
    begin
      body = JSON.parse(msg.body)
      payload = JSON.parse(body['Message'])
      check_params = ActionController::Parameters.new(payload)
      check = check_params[:check]
    rescue StandardError => e
      Rails.logger.error("error bad format for create check message #{msg}")
    return create
  end


end
