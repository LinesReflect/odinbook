class CommentsController < ApplicationController
  def index
    @top_level_comments = Comment.where(post: params[:post_id], parent: nil).includes(:id, :user).order(likes_count: :desc).page()

    @top_level_comment_ids = @top_level_comments.map(&:id)

    @comment_replies = Comment.where(post: params[:post_id]).where.not(id: @top_level_comment_ids).includes(:user).order(likes_count: :desc)
  end
  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          if @comment.parent_id
            render turbo_stream: turbo_stream.refresh(target: "comment_#{@comment.parent_id}_new_reply")
          else
            render turbo_stream: turbo_stream.refresh(target: "post_#{@comment.post.id}_new_comment")
          end
        end
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.delete
        format.turbo_stream
      end
    end
  end

  private

  def comment_params
    params.expect(comment: [ :body, :user_id, :post_id, :parent_id ])
  end
end
