require 'google/cloud/vision'

class GoogleVisionService
    def initialize
    if Rails.env.production?
      # For production, set the credentials via environment variable
      credentials_json = ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
      if credentials_json
        begin
          # Parse and validate JSON first
          parsed_json = JSON.parse(credentials_json)

          # Write credentials to a temporary file
          temp_credentials_file = Tempfile.new(['google_credentials', '.json'])
          temp_credentials_file.write(JSON.generate(parsed_json))
          temp_credentials_file.close

          # Set the environment variable to point to the temp file
          ENV['GOOGLE_APPLICATION_CREDENTIALS'] = temp_credentials_file.path
        rescue JSON::ParserError => e
          Rails.logger.error("Invalid JSON in GOOGLE_APPLICATION_CREDENTIALS_JSON: #{e.message}")
          raise "Invalid Google Cloud credentials JSON format"
        end
      end
    end

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


# Was not working on heroku.

#require 'google/cloud/vision'

# class GoogleVisionService
#   def initialize
#     if Rails.env.production?
#       # Use config var for production
#       credentials_json = ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
#       if credentials_json
#         credentials = Google::Cloud::Vision::Credentials.new JSON.parse(credentials_json)
#         @vision = Google::Cloud::Vision.image_annotator credentials: credentials
#       else
#         @vision = Google::Cloud::Vision.image_annotator
#       end
#     else
#       # Use file for development
#       @vision = Google::Cloud::Vision.image_annotator
#     end
#   end

#   def extract_text_from_image(image_path)
#     begin
#       response = @vision.text_detection image: image_path
#       annotation = response.responses.first

#       if annotation&.text_annotations&.any?
#         annotation.text_annotations.first.description
#       else
#         "[No text detected]"
#       end

#     rescue => e
#       Rails.logger.error("Error extracting text from image: #{e.message}")
#       nil
#     end
#   end
# end

# Was working on heroku.
# require 'google/cloud/vision'

# class GoogleVisionService
#   def initialize
#     if Rails.env.production?
#       # For production, set the credentials via environment variable
#       credentials_json = ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
#       if credentials_json
#         # Write credentials to a temporary file
#         temp_credentials_file = Tempfile.new(['google_credentials', '.json'])
#         temp_credentials_file.write(credentials_json)
#         temp_credentials_file.close

#         # Set the environment variable to point to the temp file
#         ENV['GOOGLE_APPLICATION_CREDENTIALS'] = temp_credentials_file.path
#       end
#     end

#     @vision = Google::Cloud::Vision.image_annotator
#   end

#   def extract_text_from_image(image_path)
#     begin
#       response = @vision.text_detection image: image_path
#       annotation = response.responses.first

#       if annotation&.text_annotations&.any?
#         annotation.text_annotations.first.description
#       else
#         "[No text detected]"
#       end

#     rescue => e
#       Rails.logger.error("Error extracting text from image: #{e.message}")
#       nil
#     end
#   end
# end
