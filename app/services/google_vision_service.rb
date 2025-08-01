require 'google/cloud/vision'

class GoogleVisionService
  def initialize
    @vision = Google::Cloud::Vision.image_annotator
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
