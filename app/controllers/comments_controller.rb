class CommentsController < ApplicationController
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

  private

  def comment_params
    params.expect(comment: [ :body, :user_id, :post_id, :parent_id ])
  end
end
