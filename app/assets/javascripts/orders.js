$(document).ready(function () {
    state = $("#orders_payment_method_false").is(":checked")
    show_card_form(state);
});

$(document).on("click", "#orders_payment_method_true", function () {
    state = $(this).is(":checked");
    show_card_form(!state)

})

$(document).on("click", "#orders_payment_method_false", function () {
    state = $(this).is(":checked");
    show_card_form(state)
})

$(document).on("click", "#correct", function () {
    state = $(this).is(":checked");
    state2 = $("#agree").is(":checked");
    enable_submit(state, state2);
})

$(document).on("click", "#agree", function () {
    state = $(this).is(":checked");
    state2 = $("#correct").is(":checked");
    enable_submit(state, state2);
})

enable_submit = function (state, state2) {
    if (state && state2) {
        $("#order_button").attr("disabled", false);
        $("#order_button").attr("class", "big red");

    } else {
        $("#order_button").attr("disabled", true);
        $("#order_button").attr("class", "big gray");
    }
}


show_card_form = function (state) {
    if (state) {
        return $(".card-block").css("display", "block");
    } else {
        return $(".card-block").css("display", "none");
    }
};

$(document).on("submit", "#add_cart_form", function (e) {
    e.preventDefault();
    console.log($(this).val());

    var formData = new FormData($('#add_cart_form')[0]);
    $.ajax({
        type: "POST",
        url: $(this).attr('action'),
        data: formData,
        cache: false,
        processData: false,
        contentType: false,
        success: function (data) {
            $('#cart-container').html(data);
            var price = $('td#total-price').text().replace(/\s/g, '');
            $('h2.green.price-container').text('Total: ' + price);
            $("#addToCart").modal("hide");

        },
        error: function (data) {
            return false
        }

    });

    return false;
});

$(document).on('click', '.add-to-cart, .edit-from-card', function () {
    console.log('rest delete');
    console.log('add to cart');

    id = $(this).data("id");
    console.log(id);

    $("#addToCart").modal("show");

    $("#addToCart .modal-content .loading.product").css("display", "block");
    $("#addToCart .modal-content .modal-header").css("display", "none");
    $("#addToCart .modal-content .modal-body").css("display", "none");
    $("#addToCart .modal-content .modal-footer").css("display", "none");


    $.ajax({
        url: "/products/get_product",
        type: "POST",
        data: {id: id},
        success: function (data) {
            $('#addToCart .modal-dialog').html(data);
            var price = $('td#total-price').text().replace(/\s/g, '');
            $('h2.green.price-container').text('Total: ' + price);
            return false;

        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)
            return false
        }
    });

    return false
})

$(document).on('click', '.remove-from-card_api', function () {
    console.log('remove from cart');
    $.ajax({
        url: '/line_items/remove_api',
        type: 'POST',
        data: {product_id: $(this).attr('id')},
        success: function (data) {
            console.log('success------------------------------');
            console.log(data);

            $('#cart-container').html(data);
            var price = $('td#total-price').text().replace(/\s/g, '');
            $('h2.green.price-container').text('Total: ' + price);


        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)

        }

    })



    return false;

})


//$(document).on("click", "table.products tr", function() {

$(document).on("click", "table tr.clickable", function() {

    window.location = '/orders/'+$(this).data("id");

});

$(document).on("change", "#status", function() {
    status = $(this).val();
    order_id = $(this).data("id");


    $.ajax({
        url: '/orders/status',
        type: 'POST',
        data: {status: status, order_id: order_id},
        success: function (data) {

            if (data.status == 200) {
                $(".card").css("color", data.color);
                $(".card").css("border", "5px dotted " + data.color);
                $(".card").html(data.message)

            }
//            alert(data.status)
        },
        error: function (data) {
            console.log(data)

        }

    });

} )



