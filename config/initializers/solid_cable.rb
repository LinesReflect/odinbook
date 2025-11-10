Rails.application.config.after_initialize do
  SolidCable::Record.connects_to database: { writing: :primary }
end
