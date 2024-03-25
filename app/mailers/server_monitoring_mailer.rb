# frozen_string_literal: true

class ServerMonitoringMailer < ApplicationMailer
  def server_error(error_details)
    @error_details = error_details
    recipients = ServerSentry.emails_to_notify
    return if recipients.blank?
    mail(to: recipients, subject: "[Rzrv][#{Rails.env.upcase}] Server Error Notification")
  end
end
