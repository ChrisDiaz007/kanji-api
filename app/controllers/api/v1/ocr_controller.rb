class Api::V1::OcrController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:create]
  skip_after_action :verify_policy_scoped, only: [:create]
  skip_after_action :verify_authorized, only: [:create]

  def index
  end

    def create
    # Get the image file from the request
    image_file = params[:image]

    if image_file.blank?
      render json: { error: 'No image provided' }, status: :bad_request
      return
    end

    # Save the uploaded file temporarily
    temp_file = Tempfile.new(['ocr_image', File.extname(image_file.original_filename)])
    temp_file.binmode
    temp_file.write(image_file.read)
    temp_file.rewind

    # Convert HEIC to JPEG if needed
    if image_file.content_type == 'image/heic' || File.extname(image_file.original_filename).downcase == '.heic'
      converted_file = convert_heic_to_jpeg(temp_file.path)
      temp_file.close
      temp_file.unlink
      temp_file = converted_file
    end

    # Use the Google Vision service to extract text
    service = GoogleVisionService.new
    extracted_text = service.extract_text_from_image(temp_file.path)

    # Clean up the temporary file
    temp_file.close
    temp_file.unlink

    # Look up the kanji in the database
    kanji = Kanji.find_by(character: extracted_text)

    # Return both the extracted text and kanji data
    response = { text: extracted_text }

    if kanji
      response[:kanji] = kanji
    else
      response[:kanji] = nil
      response[:message] = "Kanji not found in database"
    end

    render json: response
  end

  private

  def convert_heic_to_jpeg(heic_path)
    require 'mini_magick'

    # Create a new temp file for the converted image
    jpeg_file = Tempfile.new(['converted_image', '.jpg'])

    begin
      # Use ImageMagick to convert HEIC to JPEG
      image = MiniMagick::Image.open(heic_path)
      image.format 'jpg'
      image.write(jpeg_file.path)

      jpeg_file.rewind
      jpeg_file
    rescue => e
      Rails.logger.error("Error converting HEIC to JPEG: #{e.message}")
      # If conversion fails, return the original file
      jpeg_file.close
      jpeg_file.unlink
      nil
    end
  end
end
