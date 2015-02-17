$(document).on("click", "#add_comments_blog", function(e) {
    text2 = $("#comment_comment").val();

    blog_id2 = $("#blog_id").val();

    console.log(blog_id2);

    console.log(text2);

    if (text2 != "") {
        addBComment(text2, blog_id2);
    }


    e.preventDefault();

    return false;
});


function addBComment(text, blog_id) {
    console.log(blog_id);

    console.log(text);
    $.ajax({
        url: "/comments/create",
        type: "POST",
        data: {comment: text2, blog_id: blog_id2},
        success: function(data) {
            $(".comments-list").html(data);
            $("#comment_comment").val("");
        },

        error: function(data) {

        }
    });

    return false;
}

