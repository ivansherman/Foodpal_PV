class CommentsController < ApplicationController

  def create
    puts params.inspect.red

    if params["rest_id"]
      restaurant = Restaurant.find_by_id(params["rest_id"])

      comment = restaurant.comments.new(comment: params[:comment])

      comment.user_id = current_user.id

      if comment.save
        render partial: "comments/comment", locals: {restaurant: restaurant}
      else
        render partial: "comments/comment", locals: {restaurant: restaurant}
      end
    end

    if params["blog_id"]
      puts params.inspect.green

      blog = Blog.find_by_id(params["blog_id"])

      comment = blog.comments.new(comment: params[:comment])

      comment.user_id = current_user.id

      if comment.save
        render partial: "comments/blogs_comments", locals: {blog: blog}
      else
        render partial: "comments/blogs_comments", locals: {blog: blog}
      end
    end
  end
end
