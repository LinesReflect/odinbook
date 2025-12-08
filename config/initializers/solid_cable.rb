# config/initializers/solid_cable.rb
unless Rails.env.test? || [ "rake", "rails" ].include?(File.split($0).last)
  Rails.application.config.after_initialize do
    SolidCable::Record.connects_to database: { writing: :primary }
  end
end
