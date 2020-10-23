class CreateChecksJob < ActiveJob::Base
  def perform(queue_url)
    poller = Aws::SQS::QueuePoller.new(queue_url)
    Rails.logger.info('polling messages')
    poller.poll(skip_delete: true, max_number_of_messages: 10) do |messages|
      messages.each do |msg|
        begin
          body = JSON.parse(msg.body)
          payload = JSON.parse(body['Message'])
          check_params = ActionController::Parameters.new(payload)
          Rails.logger.info('Check params ' + check_params.inspect)
          ChecksHelper.create_check_with_id(check_params[:check])
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
end
