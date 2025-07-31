class Api::V1::UserKanjisController < Api::V1::BaseController
  def index
    @user_kanjis = policy_scope(UserKanji)
    render json: @user_kanjis
  end

  def show
    @user_kanji = UserKanji.find(params[:id])
    authorize @user_kanji
    render json: @user_kanji
  end

  def create
    @user_kanji = UserKanji.new(user_kanji_params)
    authorize @user_kanji
    if @user_kanji.save
      render json: @user_kanji
    else
      render json: { errors: @user_kanji.errors }, status: :unprocessable_entity
    end
  end

  def update?
    @user_kanji = UserKanji.find(find(params[:id]))
    authorize @user_kanji
    if @user_kanji.update(user_kanji_params)
      render json: @user_kanji
    else
      render json: { errors: @user_kanji.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @user_kanji = UserKanji.find(params[:id])
    authorize @user_kanji
    @user_kanji.destroy
    head :no_content
  end

  private

  def user_kanji_params
    params.require(:user_kanji).permit(:kanji_id)
  end
end
