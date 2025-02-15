# frozen_string_literal: true

module RequestTimeouts
  extend ActiveSupport::Concern

  included do
    rescue_from Rack::Timeout::RequestTimeoutException, with: :timeout_response if defined? Rack::Timeout
  end

  private

  def timeout_response(_exception = nil)
    respond_to do |type|
      type.html {
        render status: :gateway_timeout,
               file: Rails.root.join("public/500.html"),
               formats: [:html],
               layout: nil
      }
      type.all { render status: :gateway_timeout, body: nil }
    end
  end
end
