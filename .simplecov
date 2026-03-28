#!/usr/bin/env ruby

SimpleCov.start do
  track_files "{app,lib}/**/*.rb"

  add_filter "/app/channels/"
  add_filter "/app/helpers/"
  add_filter "/app/jobs/"
  add_filter "/app/mailers/"
  add_filter "/app/workers/"
  add_filter "/bin/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter "/lib/assets/"
  add_filter "/lib/tasks/"
  add_filter "/node_modules/"
  add_filter "/spec/"
  add_filter "/tmp/"
  add_filter "/vendor/"

  add_group "Controllers", "app/controllers"
  add_group "Models", "app/models"
  add_group "Services", "app/services"
  add_group "Serializers", "app/serializers"
  add_group "Lib", "lib/"

  enable_coverage :branch

  # minimum_coverage line: 70, branch: 50
  # minimum_coverage_by_file line: 70, branch: 50
  # maximum_coverage_drop line: 10, branch: 5
end
