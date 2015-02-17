class ProductsController < ApplicationController
  def create
    puts params.inspect.bold.magenta

    @menu = Menu.find_by_id(params[:product][:menu_id])
    @product = Product.new(params[:product])

    if @product.save
      flash[:success] = "Product added"
      render partial: "products/list", locals: {menu: @menu}
    else

      render partial: "products/list", locals: {menu: @menu}
    end


  end

  def update
    puts params.inspect.red

    @product = Product.find_by_id(params[:product][:id])
    @menu = @product.menu

    if @product.update_attributes(params[:product])
      render partial: "products/list", locals: {menu: @menu}
    else
      render partial: "products/list", locals: {menu: @menu}
    end



  end

  def delete
    puts params.inspect.red
    @product = Product.find_by_id(params[:id])
    @menu = @product.menu

    if @product.destroy
      render partial: "products/list", locals: {menu: @menu}
    else
      render partial: "products/list", locals: {menu: @menu}
    end

  end

  def edit

    puts params.inspect.green

    @product = Product.find_by_id(params[:id])
    #
    @menu = @product.menu
    #
    if @product
      render partial: "products/edit", locals: {menu: @menu}

    else
      flash[:error] = "No item found"
      render partial: "products/edit", locals: {menu: @menu}
    end
  end

  def get_product

    puts params.inspect.yellow

    product = Product.find_by_id(params[:id])

    puts(current_cart.inspect.green)

    render partial: "carts/edit", locals: {product: product, cart: current_cart}

  end
end
