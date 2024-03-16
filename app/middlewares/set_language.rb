class SetLanguage
  def initialize(app)
    @app = app
  end

  def call(env)
    @lang = env["HTTP_ACCEPT_LANGUAGE"]
    locale = set_locale_based_on_header
    I18n.with_locale(locale) do
      @status, @headers, @response = @app.call(env)
    end

    [@status, @headers, @response]
  end

  private

  def set_locale_based_on_header
    locale = @lang&.scan(/^[a-z]{2}/)&.first
    locale_valid?(locale) ? locale : I18n.default_locale
  end

  def locale_valid?(locale)
    I18n.available_locales.map(&:to_s).include?(locale)
  end
end
