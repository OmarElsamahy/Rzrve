# Usage: rake deploy
# Usage: rake env deploy
desc "Deploy to the specified environment"

task deploy: :environment do
  environment = ENV["environment"] || ARGV[0]
  if environment.nil?
    raise ArgumentError, "No environment specified, please specify an environment either by passing it as an ENV variable (e.g., rake deploy environment=staging)
        or by specifying it after the task (e.g., rake staging deploy).".squish
  end
  Rake::Task["vlad:update"].invoke
  Rake::Task["vlad:setup_env_files"].invoke
  Rake::Task["vlad:startup_script"].invoke
  Rake::Task["vlad:authorize_owner"].invoke
  Rake::Task["vlad:cleanup"].invoke
  ConsoleLogger.instance.logger.info("🚀 #{environment.upcase} DEPLOYMENT SUCCESSFUL 🚀")
rescue ArgumentError => e
  ConsoleLogger.instance.logger.fatal(e.message)
rescue => e
  ConsoleLogger.instance.logger.fatal("#{environment.upcase} DEPLOYMENT FAILURE: #{e.message}")
end
