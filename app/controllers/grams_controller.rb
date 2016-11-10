class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @grams = Gram.all
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = current_user.grams.create(gram_params)
    if @gram.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    render_404 if current_gram.blank?
  end

  def edit
    if current_gram.blank?
      render_404
    else
      if current_user != current_gram.user
        render text: 'Forbidden', status: :forbidden
      else
        @gram = current_gram
      end
    end
  end

  def update
    if current_gram.blank?
      render_404
    else
      if current_user != current_gram.user
        render text: "Forbidden", status: :forbidden
      else
        current_gram.update_attributes(gram_params)
        if current_gram.valid?
          redirect_to root_path
        else
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    if current_gram.blank?
      render_404
    else
      if current_user != current_gram.user
        render text: 'Forbidden', status: :forbidden
      else
        current_gram.destroy
        redirect_to root_path
      end
    end
  end

  private

  def gram_params
    params.require(:gram).permit(:caption)
  end

  def render_404
    render text: 'Not found', status: :not_found
  end

  helper_method :current_gram
  def current_gram
    @current_gram ||= Gram.find_by_id(params[:id])
  end

end
