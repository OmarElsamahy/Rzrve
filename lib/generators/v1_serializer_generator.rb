class Generators::V1SerializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def generate_serializer
    template "v1_serializer.rb.erb", File.join("app/serializers/api/v1", class_path, "#{file_name}_serializer.rb")
  end
end
