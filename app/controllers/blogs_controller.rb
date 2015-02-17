class BlogsController < ApplicationController

  before_filter :unauthorized, except: [:index, :show]

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Blog", :blogs_path

  def index
    @blogs = Blog.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)

  end

  def show
    @blog = Blog.find_by_id(params["id"])

    add_breadcrumb @blog.title , :blog_path
  end

  def update
    @blog = Blog.find_by_id(params["id"])
    if @blog.update_attributes(params["blog"])
      redirect_to @blog
    end
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = current_user.blogs.new(params[:blog])

    if @blog.save

      flash[:success] = "Blog \"" + @blog.title + "\" created"
      redirect_to blog_path(@blog)

    else
      flash[:error] = @blog.errors.messages
      render "new"
    end
  end

  def destroy
    @blog = Blog.find_by_id(params[:id])

    @blog.destroy

    flash[:success] = "Blog deleted"
    redirect_to blogs_path
  end



end
