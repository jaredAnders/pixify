class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    return render_404 if current_gram.blank?
    current_gram.comments.create(comment_params.merge(user: current_user))
    redirect_to gram_path(current_gram)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def render_404
    render text: 'Not found', status: :not_found
  end

  helper_method :current_gram
  def current_gram
    @current_gram ||= Gram.find_by_id(params[:gram_id])
  end

end
