require "digest"
require "uri"

module Gravatar
  # Create the SHA256 hash
  def email_hash
    Digest::SHA256.hexdigest(self.email.downcase)
  end
  # Set default URL and size parameters
  def image_default
    "https://www.example.com/default.jpg"
  end

  def image_404
    "404"
  end

  def image_size
    40
  end

  # Compile the full URL with URI encoding for the parameters
  def default_image_params
    URI.encode_www_form("d" => image_default, "s" => image_size)
  end

  def image_params_404
    URI.encode_www_form("d" => image_404)
  end

  def image_src(params)
    "https://www.gravatar.com/avatar/#{email_hash}?#{params}"
  end

  def has_gravatar?
    RestClient.get(image_src(image_params_404))
    true

  rescue RestClient::NotFound

    false
  end
end
