# config/initializers/solid_cable.rb
unless Rails.env.test? || File.split($0).last([ "rake", "rails" ])
  Rails.application.config.after_initialize do
    SolidCable::Record.connects_to database: { writing: :primary }
  end
end
