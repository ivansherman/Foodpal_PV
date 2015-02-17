class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  # attr_accessible :title, :body
  def add_product(product_id)
    current_item = line_items.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
    end
    current_item
  end

  def api_add_product(product_id)
    current_item = line_items.find_by_product_id(product_id)
    if current_item
      current_item.quantity +=1
    else
      current_item = line_items.build(product_id: product_id)
    end
    current_item.save
    current_item
  end

  def remove_product(line_item)
    puts '----------------------------remove-----product------------------------'
    puts line_item.inspect.green.bold
    if line_item.quantity > 1
      line_item.quantity -=1
      line_item.save

    else
      line_item.destroy
    end
  end

end
