#!/usr/bin/env ruby

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter "/vendor/"
  add_filter "/node_modules/"
  add_filter "/tmp/"
  add_filter "/bin/"

  add_group "Controllers", "app/controllers"
  add_group "Models", "app/models"
  add_group "Services", "app/services"
  add_group "Serializers", "app//serializers"

  enable_coverage :branch

  minimum_coverage 70
  minimum_coverage_by_file 70
  #   maximum_coverage_drop 5
end
