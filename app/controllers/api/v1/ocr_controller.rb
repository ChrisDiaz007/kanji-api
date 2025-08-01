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

end
