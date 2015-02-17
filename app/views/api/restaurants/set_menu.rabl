collection :@menu

attributes :id, :name

child :products do
     attributes :name

     node :price do |product|
       product.price.sub(',','.').to_f || 0
     end

     node :product_id do |product|
       product.id
     end
end

