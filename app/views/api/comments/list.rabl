collection :@comments

attributes :id, :restaurant_id

node :user_name do |comment|
   comment.user.name
end

node :user_avatar do |comment|
   comment.user.avatar.url(:thumb)
end

node :review do |comment|
   comment.comment
end

node :date do |comment|
   comment.created_at
end

