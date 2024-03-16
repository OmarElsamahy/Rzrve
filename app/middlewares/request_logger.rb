class RequestLogger
  def initialize(app, formatting_char = "=")
    @app = app
    @formatting_char = formatting_char
  end

  def call(env)
    request_started_on = Time.zone.now
    logger ||= Logger.new("#{Rails.root.join("log/api_calls.log")}")
    logger.info @formatting_char * 50
    logger.info "Request method:  #{env["REQUEST_METHOD"]}"
    logger.info "Request url: #{env["HTTP_HOST"]}#{env["REQUEST_URI"]}"
    logger.info "Header Authorization: #{env["HTTP_AUTHORIZATION"]}"

    @status, @headers, @response = @app.call(env)
    request_ended_on = Time.zone.now
    logger.info("End of request #{env["REQUEST_URI"]} with response #{@status}")

    logger.info "Response status: #{@status}"

    logger.info "Request time: #{request_ended_on - request_started_on} seconds."

    logger.info @formatting_char * 50

    [@status, @headers, @response]
  end
end
