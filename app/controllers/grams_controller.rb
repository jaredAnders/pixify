class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @grams = Gram.order(:created_at).reverse_order
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = current_user.grams.create(gram_params)
    return redirect_to root_path if @gram.valid?
    render :new, status: :unprocessable_entity
  end

  def show
    return render_status(:not_found) if current_gram.blank?
    @comment = Comment.new
  end

  def edit
    return render_status(:not_found) if current_gram.blank?
    return render_status(:forbidden) if current_user != current_gram.user
    @gram = current_gram
  end

  def update
    return render_status(:not_found) if current_gram.blank?
    return render_status(:forbidden) if current_user != current_gram.user
    current_gram.update_attributes(gram_params)
    return redirect_to root_path if current_gram.valid?
    render :edit, status: :unprocessable_entity
  end

  def destroy
    return render_status(:not_found) if current_gram.blank?
    return render_status(:forbidden) if current_user != current_gram.user
    current_gram.destroy
    redirect_to root_path
  end

  private

  def gram_params
    params.require(:gram).permit(:caption, :image)
  end

  def render_status(status)
    render text: "#{status.to_s.titleize}", status: status
  end

  helper_method :current_gram
  def current_gram
    @current_gram ||= Gram.find_by_id(params[:id])
  end

end
