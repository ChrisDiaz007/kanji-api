require 'google/cloud/vision'

class GoogleVisionService
  def initialize
    if Rails.env.production?
      # Use config var for production
      credentials_json = ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
      if credentials_json
        credentials = Google::Cloud::Vision::Credentials.new JSON.parse(credentials_json)
        @vision = Google::Cloud::Vision.image_annotator credentials: credentials
      else
        @vision = Google::Cloud::Vision.image_annotator
      end
    else
      # Use file for development
      @vision = Google::Cloud::Vision.image_annotator
    end
  end

  def extract_text_from_image(image_path)
    begin
      response = @vision.text_detection image: image_path
      annotation = response.responses.first

      if annotation&.text_annotations&.any?
        annotation.text_annotations.first.description
      else
        "[No text detected]"
      end

    rescue => e
      Rails.logger.error("Error extracting text from image: #{e.message}")
      nil
    end
  end
end
