//= require jquery.more.js
//= require info.builder.js

function getHashParams() {

    var hashParams = {};
    var e,
        a = /\+/g,  // Regex for replacing addition symbol with a space
        r = /([^&;=]+)=?([^&;]*)/g,
        d = function (s) { return decodeURIComponent(s.replace(a, " ")); },
        q = window.location.hash.substring(1);

    while (e = r.exec(q))
        hashParams[d(e[1])] = d(e[2]);

    return hashParams;
}


var iconYou = new google.maps.MarkerImage("assets/you.png",
    new google.maps.Size(20, 27),
    new google.maps.Point(0, 0),
    new google.maps.Point(20, 27));

function codeLatLng(lat, lng, callback) {

    geocoder = new google.maps.Geocoder();
    var latlng = new google.maps.LatLng(lat, lng);
    geocoder.geocode({'latLng': latlng}, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            //console.log(results);

            if (results[1]) {
                callback(results[1].formatted_address);
            } else {
                callback("No results found");
//                       } else {
                callback("No results found");
            }
            //}
        } else {
            callback("Geocoder failed due to: " + status);
        }
    });

}

function showLocation(position) {
    var add;
    codeLatLng(position.coords.latitude, position.coords.longitude, function (addr) {
        add = addr;
    });

    //console.log(add);
    handler = Gmaps.build('Google', { builders: { Marker: InfoBoxBuilder} });
    handler.buildMap({ provider: {maxZoom: 15}, internal: {id: 'map'}}, function () {


        markers = handler.addMarkers([
            {
                "lat": position.coords.latitude,
                "lng": position.coords.longitude,
                "picture": {
                    "url": "/assets/you.png",
                    "width": 36,
                    "height": 36
                },


                "infowindow": "<div class=\"location\"><h1 style=\"color: #ffffff; font-size: 14px\">Your location is here </h1><br>" + add + "</div>"
            }
        ]);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();

    });

    $("#map-loader .image").css("display", "none");

}

function showError(error) {
    switch (error.code) {
        case error.PERMISSION_DENIED:
            alert("User denied the request for Geolocation.");
            break;
        case error.POSITION_UNAVAILABLE:
            alert("Location information is unavailable.");
            break;
        case error.TIMEOUT:
            alert("The request to get user location timed out.");
            break;
        case error.UNKNOWN_ERROR:
            alert("An unknown error occurred.");
            break;
    }

}

function loadData() {

    keyword = $('#new_cuisine #name').val();
    cuisine = $('#new_cuisine #cuisine').val();
    delivery = $("#new_cuisine :checked").val();
    filter = $("#togle-buttons").find(".active").data("filter");

    window.history.pushState(null,null, "#key=" +  keyword + "&cuisine=" + cuisine + "&delivery=" + delivery + "&filter=" + filter);

    $.ajax({
        url: 'restaurants/search',
        type: 'POST',
        cache: true,
        data: {zip: keyword,
            cuisine: cuisine,
            delivery: delivery,
            filter: filter},
        success: function (data) {

            $('#restaurant_list').html(data);

            var params = getHashParams();

            localStorage.setItem('rest-data', data);
            localStorage.setItem('keyword', params.key);
            localStorage.setItem('cuisine', params.cuisine);
            localStorage.setItem('delivery', params.delivery);
            localStorage.setItem('filter', params.filter != "" ? params.filter : 0);

            $("#map-loader .image").css("display", "none");
        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)
        }

    });
}

$(document).on('click', '#search_form', function () {
    console.log('search');

    $("#map-loader .image").css("display", "block");

    loadData();


    return false;

})

$(document).on("submit", "#add_cart_form", function(e) {
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
            $("#addToCart").modal("hide");

        },
        error: function (data) {
            return false
        }

    });

return false;
});

$(document).on('click', '.add-to-cart, .edit-from-card', function () {
    console.log('rest');

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
            return false

        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)
            return false
        }
    });


    return false;

})


$(document).on('click', '.remove-from-card_api', function () {
    $.ajax({
        url: '/line_items/remove_api',
        type: 'POST',
        data: {product_id: $(this).attr('id')},
        success: function (data) {
            console.log('success------------------------------');
            console.log(data);
            $('#cart-container').html(data);


        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)

        }

    })


    return false;

})


$(document).on("click", "#add_comment", function (e) {
    text = $("#comment_comment").val();

    console.log(text)

    if (text != "") {
        addComment(text);
    }


    e.preventDefault();

    return false;
});


function addComment(text) {
    rest_id = $("#rest_id").val();
    $.ajax({
        url: "/comments/create",
        type: "POST",
        data: {comment: text, rest_id: rest_id},
        success: function (data) {
            $(".comments-list").html(data);
            $("#comment_comment").val("");
        },

        error: function (data) {

        }
    });

    return false;
}


$(document).on("click", "#recommended", function (e) {

    keyword = $(".craving #name").val();

    if (keyword.length > 0) {
        $(".loading.restaurant").css("display", "block");
        $(".loading.blogs").css("display", "block");
        $('#myModal').modal("show");
        recommendRestaurant(keyword);
        recommendBlog(keyword);


    } else {
        alert("Put a Keyword, please");
    }

    return false;
});


function recommendRestaurant(keyword) {

    $.ajax({
        url: "/restaurants/craving_restaurants",
        type: "POST",
        data: {keyword: keyword},
        success: function (data) {
            $("#rest.tab-pane").html(data);

            $(".loading.restaurant").css("display", "none");

        },

        error: function (data) {
            console.log(data)
        }
    });
}

function recommendBlog(keyword) {

    $.ajax({
        url: "/restaurants/craving_blogs",
        type: "POST",
        data: {keyword: keyword},
        success: function (data) {
            $("#blogs.tab-pane").html(data);

            $(".loading.blogs").css("display", "none");

        },

        error: function (data) {
            console.log(data)
        }
    });


}


// =======================

$(document).on("click", ".delete-image", function () {
    id = $(this).data("id");
    console.log("  => on delete image click [/gallery/delete]");

    if (confirm('Are you sure you want to delete this image?')) {
        console.log("Delete: " + id);

        $.ajax({
            url: '/gallery/delete',
            type: 'DELETE',
            data: {id: id},
            success: function (data) {

                $(".gallery").html(data);

            },
            error: function (data) {
                console.log('error------------------------------');
                console.log(data)

            }

        })

    } else {
        console.log("Cancel");
    }
});


$(document).on("click", ".new", function () {
    console.log("  => on new image click");
    $("#gallery_image").val("");
    $('#addImage').modal("show");
});


$(document).on("submit", "#imageUploadForm", function (e) {
    console.log("  => on upload image form submit ");

    $(".form").css("display", "none");
    $(".modal-footer").css("display", "none");
    $(".writing.gallery").css("display", "block");


    e.preventDefault();

    var formData = new FormData($('#imageUploadForm')[0]);
    $.ajax({
        type: 'POST',
        url: $(this).attr('action'),
        data: formData,
        cache: false,
        processData: false,
        contentType: false,

        success: function (data) {
            console.log("success");

            console.log("not closed");

            $(".form").css("display", "block");
            $(".modal-footer").css("display", "block");
            $(".writing.gallery").css("display", "none");



//            $('#addImage').modal({show:false});
            $('#addImage').modal("hide");
//            $('.modal-backdrop').remove();
//            $('body').removeClass('modal-open');
            $(".gallery").html(data);


        },
        error: function (data) {
            console.log("error");
            console.log(data);
        }
    });

    return true;

});


$(document).on("click", ".label.label-default.add", function (e) {
    console.log("  => on cuisine add click");

    $('#addCuisine').modal("show")
})

$(document).on("submit", "#cuisineAddForm", function (e) {
    console.log("  => on cuisine add form submit");

    $(".form").css("display", "none");
    $(".modal-footer").css("display", "none");
    $(".writing.cuisine").css("display", "block");

    e.preventDefault();

    var formData = new FormData($('#cuisineAddForm')[0]);
    $.ajax({
        type: 'POST',
        url: $(this).attr('action'),
        data: formData,
        cache: false,
        processData: false,
        contentType: false,

        success: function (data) {

            $('.cuisines').html(data);


            $('#addCuisine').modal('hide');
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();

            $(".form").css("display", "block");
            $(".modal-footer").css("display", "block");
            $(".writing.cuisine").css("display", "none");


        },
        error: function (data) {
            console.log("error");
            console.log(data);
        }
    });

    return false;

});


$(document).on("click", ".label.label-primary.get", function (e) {
    console.log("  => on cuisine delete click [/cuisines/delete]");
    id = $(this).data("id");

    if (confirm('Are you sure you want to delete this image?')) {
        console.log("Delete: " + id);

        $.ajax({
            url: '/cuisines/delete',
            type: 'DELETE',
            data: {id: id},
            success: function (data) {

                $(".cuisines").html(data);

            },
            error: function (data) {
                console.log('error------------------------------');
                console.log(data)

            }

        })

    } else {
        console.log("Cancel");
    }
})


//$(document).on("submit", ".edit_restaurant", function(e) {
//    console.log("  => on edit restaurant submit");
//    e.preventDefault();
//    var formData = new FormData($('.edit_restaurant')[0]);
//    $.ajax({
//        type:'PUT',
//        url: $(this).attr('action'),
//        data: formData,
//        cache:false,
//        processData: false,
//        contentType: false,
//
//        success: function(data){
//            console.log("success");
//            $('#restaurant.tab-pane').html(data);
//
//
//        },
//        error: function(data){
//            console.log("error");
//            console.log(data);
//        }
//    });
//
//    return false;
//
//});

$(document).on("click", ".addLocations", function (e) {
    console.log("  => on location add click");
    $("form.edit_location").css("display", "none");
    $(".loading.location").css("display", "block");
    rest_id = $(".addLocations").data("rest_id");
    $.ajax({
        url: '/locations/edit',
        type: 'POST',
        data: {rest_id: rest_id},
        success: function (data) {
            $(".location-form").html(data);
            $('#addLocations').modal("show");
            $("form.edit_location").css("display", "block");
            $(".loading.location").css("display", "none");

        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)

        }

    })

//    $('#addLocations').modal("show");

})


$(document).on('shown.bs.modal', '#addLocations', function () {
    console.log("  => on location add modal show");

    selectlocationState($("#location_id"));


    console.log($("#map").css("display"));

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showLocation, showError);


    } else {
        alert("Geolocation is not supported by this browser.")
    }
});


//function showLocation(position) {
//    console.log("  => on locations show");
//    handler = Gmaps.build('Google');
////        handler.setZoom(4);
//    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
//
//
//
//        markers = handler.addMarkers([
//            {
//                "lat": position.coords.latitude,
//                "lng": position.coords.longitude,
//                "picture": {
//                    "url": "assets/you.png",
//                    "width":  36,
//                    "height": 36
//                },
//
//                "infowindow": "<div class=\"location\">This is you: <br \/>Latitude: " + position.coords.latitude + "<br \/>Longitude: " + position.coords.longitude + "</div>"
//            }
//        ]);
//        handler.bounds.extendWith(markers);
//        handler.fitMapToBounds();
//
//        var marker = new google.maps.Marker({map: handler.getMap()});
//
//        var map = handler.getMap();
//
//        google.maps.event.addListener(map, "click", function(event)
//        {
//            marker.setPosition(event.latLng);
//
//            $("#location_latitude").val(event.latLng.lat());
//            $("#location_longitude").val(event.latLng.lng());
//        });
//
//
//    });
//
//}

function showError(error) {
    switch (error.code) {
        case error.PERMISSION_DENIED:
            alert("User denied the request for Geolocation.");
            break;
        case error.POSITION_UNAVAILABLE:
            alert("Location information is unavailable.");
            break;
        case error.TIMEOUT:
            alert("The request to get user location timed out.");
            break;
        case error.UNKNOWN_ERROR:
            alert("An unknown error occurred.");
            break;
    }

}


$(document).on("submit", "#locationsAddForm", function (e) {
    console.log("  => on locations add form submit");
    $("form#locationsAddForm").css("display", "none");
    $(".writing.location").css("display", "block");
    e.preventDefault();

    var formData = new FormData($('#locationsAddForm')[0]);
    $.ajax({
        type: 'POST',
        url: $(this).attr('action'),
        data: formData,
        cache: false,
        processData: false,
        contentType: false,

        success: function (data) {
            $('#addLocations').modal('hide');
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();

            $("form#new_location").css("display", "block");
            $(".writing.location").css("display", "none");

            $(".locations").html(data);
            console.log("success");


        },
        error: function (data) {
            console.log("error");
            console.log(data);
        }
    });

    return false;

});


function selectlocationState(t) {
    console.log("  => select locations state [/locations/get_l_state]");
    $.ajax({
        url: '/locations/get_l_state',
        type: 'GET',
        data: {id: $(t).val()},
        success: function (data) {
            if (data) {
                $(".locations #state option[value=" + data["id"] + "]").attr("selected", "selected");
                selectLState("#state select");
                selectLocationCity("#location_id");
            }


        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)

        }

    })
}


function selectLState(t) {
    console.log("  => select L state select");

    $.ajax({
        url: '/locations/select_state',
        type: 'GET',
        data: {id: $(t).val()},
        success: function (data) {
            answer = data;
            $('.locations #city').css('display', 'block');
            options = '';
            for (i in data) {
                options += '<option value="' + data[i]['id'] + '">' + data[i]['city'] + '</option>';

            }
            $('.locations #city select').html(options);


        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)

        }

    })
}

function selectLocationCity(t) {
    console.log("  => select locations city [/locations/get_l_city]");

    $.ajax({
        url: '/locations/get_l_city',
        type: 'GET',
        data: {id: $(t).val()},
        success: function (data) {
            if (data) {
                $(".locations #city option[value=" + data["id"] + "]").attr("selected", "selected");
            }


        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)

        }

    })
}

$(document).on("change", ".locations #state select", function () {
    console.log("  => on state edit L state select ");
    selectLState(this);
});

$(document).on("click", "a.edit_location", function () {
    console.log("  => on edit location click ");
    $("form#locationsAddForm").css("display", "none");
    $(".writing.location").css("display", "block");
    $('#addLocations').modal("show");
    id = $(this).data("id");
    console.log(id);
    $.ajax({
        url: '/locations/edit',
        type: 'POST',
        data: {id: id},
        success: function (data) {
            $(".location-form").html(data);

            $("form#new_location").css("display", "block");
            $(".writing.location").css("display", "none");


        },
        error: function (data) {
            console.log('error------------------------------');
            console.log(data)

        }

    })
    return false
})

$(document).on("click", "a.delete_location", function () {

    console.log("  => on location delete click [/cuisines/delete]");
    id = $(this).data("id");

    if (confirm('Are you sure you want to delete this location?')) {
        console.log("Delete: " + id);

        $.ajax({
            url: '/locations/delete',
            type: 'DELETE',
            data: {id: id},
            success: function (data) {

                $(".locations").html(data);

            },
            error: function (data) {
                console.log('error------------------------------');
                console.log(data);

            }

        })

    } else {
        console.log("Cancel");
    }

    return false;

});

$(document).on("click", "a.menu, a#add_more_menu", function (e) {
    $("#addMenu .modal-content #menu_name").val("");
    $("#addMenu .modal-content #menu_description").val("");
    $("#addMenu .modal-content #menu_id").val("");
    $("#addMenuForm").attr("action", "/menus/create");

    $("#addMenu").modal("show");

    return false;
});


$(document).on("submit", "#addMenuForm", function (e) {
    console.log("  => on menu add form submit");
//    $("form#locationsAddForm").css("display", "none");
//    $(".writing.location").css("display", "block");
    e.preventDefault();

    var formData = new FormData($('#addMenuForm')[0]);
    $.ajax({
        type: 'POST',
        url: $(this).attr('action'),
        data: formData,
        cache: false,
        processData: false,
        contentType: false,

        success: function (data) {
            $('#addMenu').modal('hide');
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();
//
//            $("form#new_location").css("display", "block");
//            $(".writing.location").css("display", "none");

            $(".menus").html(data);
            console.log("success");

        },
        error: function (data) {
            console.log("error");
            console.log(data);
        }
    });

    return false;
});

$(document).on("click", "a.edit", function (e) {
    console.log("  => on menu edit click");

    id = $(this).data("id");

    console.log(id)

    if (id > 0) {

        getMenuInfo(id);
//        $("#addMenuForm").attr("action", "/menus/update");
        $("#addMenu").modal("show");

    }


    return false;
});

function getMenuInfo(id) {
    if (id > 0) {
        $.ajax({
            type: 'POST',
            url: "/menus/edit",
            data: {id: id},

            success: function (data) {
//                $('#addMenu').modal('hide');
//                $('body').removeClass('modal-open');
//                $('.modal-backdrop').remove();
//
//            $("form#new_location").css("display", "block");
//            $(".writing.location").css("display", "none");

                $("#addMenu .modal-content").html(data);
                console.log("success");
                $("#addMenuForm").attr("action", "/menus/update");


            },
            error: function (data) {
                console.log("error");
                console.log(data);
            }
        });
    }
}

$(document).on("click", "a.delete", function (e) {
    console.log("  => on menu edit click");

    if (confirm('Are you sure you want to delete this menu?')) {
        id = $(this).data("id");

        console.log(id)

        if (id > 0) {

            deleteMenu(id);

        }
    }

    return false;
});

function deleteMenu(id) {
    if (id > 0) {
        $.ajax({
            type: 'DELETE',
            url: "/menus/delete",
            data: {id: id},

            success: function (data) {
//                $('#addMenu').modal('hide');
//                $('body').removeClass('modal-open');
//                $('.modal-backdrop').remove();
//
//            $("form#new_location").css("display", "block");
//            $(".writing.location").css("display", "none");

                $(".menus").html(data);
                console.log("success");
            },
            error: function (data) {
                console.log("error");
                console.log(data);
            }
        });
    }
}


$(document).on("click", ".products .add_first, .products .add_more", function (e) {

    id = $(this).data("id");
    console.log(id);

    $("#addProduct_" + id + " #product_name").val("");
    $("#addProduct_" + id).find("#product_description").val("");
    $("#addProduct_" + id).find("#product_price").val("");
    $("#addProduct_" + id).find("#product_image").val("");

    console.log("#addProduct_" + id + " #product_name");
    console.log($("#addProduct_" + id));

    $("#addProduct_" + id + " #addProductForm").attr("action", "/products/create");
    $("#addProduct_" + id + " #addProductForm").attr("method", "POST");

    $("#addProduct_" + id).modal("show");
    return false;
})


$(document).on("submit", "#addProductForm", function (e) {
    console.log("  => on product add form submit");
//    $("form#locationsAddForm").css("display", "none");
//    $(".writing.location").css("display", "block");
    e.preventDefault();

    console.log($(this));

    var m_id = $(this).find("#product_menu_id").val();
    var formData = new FormData($(this)[0]);
    $.ajax({
        type: 'POST',
        url: $(this).attr('action'),
        data: formData,
        cache: false,
        processData: false,
        contentType: false,

        success: function (data) {


            $("#addProduct_" + m_id).modal('hide');
            $('body').removeClass('modal-open');
            $('.modal-backdrop').remove();
//
//            $("form#new_location").css("display", "block");
//            $(".writing.location").css("display", "none");

            $("#collapse_" + m_id + " .products").html(data);


            console.log("collapse_" + m_id + " .products");

        },
        error: function (data) {
            console.log("error");
            console.log(data);
        }
    });

    return false;
});

$(document).on("click", ".pedit", function (e) {


    id = $(this).data("id");
    console.log(id);


    if (id > 0) {
        m_id = $(this).data("m_id");
        console.log(m_id);
        getPInfo(id, m_id);
        $("#addProduct_" + m_id).modal("show");
    }

    return false;
})

function getPInfo(id, m_id) {
    if (id > 0) {
        $.ajax({
            type: 'POST',
            url: "/products/edit",
            data: {id: id},

            success: function (data) {
//                $('#addMenu').modal('hide');
//                $('body').removeClass('modal-open');
//                $('.modal-backdrop').remove();
//
//            $("form#new_location").css("display", "block");
//            $(".writing.location").css("display", "none");


                $("#addProduct_" + m_id + " .modal-content").html(data);
                console.log("success");
                $("#addProduct_" + m_id + " #addProductForm").attr("action", "/products/update");
                $("#addProduct_" + m_id + " #addProductForm").attr("method", "PUT");


            },
            error: function (data) {
                console.log("error");
                console.log(data);
            }
        });
    }
}

$(document).on("click", ".pdelete", function (e) {
    id = $(this).data("id");
    m_id = $(this).data("m_id");
    console.log(id, m_id);

    deleteProduct(id, m_id);

    return false;
})

function deleteProduct(id, m_id) {
    if (id > 0) {

        $.ajax({
            type: 'DELETE',
            url: "/products/delete",
            data: {id: id},

            success: function (data) {
//                $('#addMenu').modal('hide');
//                $('body').removeClass('modal-open');
//                $('.modal-backdrop').remove();
//
//            $("form#new_location").css("display", "block");
//            $(".writing.location").css("display", "none");

                $("#collapse_" + m_id + " .products").html(data);
                console.log("success");
            },
            error: function (data) {
                console.log("error");
                console.log(data);
            }
        });
    }
}


$(document).on('click', '#load_excel', function(e){
          console.log('click');
        var myRe = /\.xlsx$/;
        var myRe2 = /\.xls$/;
         console.log(myRe) ;
        var val = myRe.exec($('#excel').val());
        var val2 = myRe2.exec($('#excel').val());
    console.log($('#load_excel').val()) ;
    console.log(val) ;
        if( val !=null || val2 !=null){

//           alert('File has wrong format (must be .xlsx)');
        }
        else{
            e.preventDefault();
            alert('File has wrong format (must be .xlsx or .xls)');
//            $('.align-error').html("<div class='alert alert-error'>File was no choose or bad file formal</div>");

        }

    });

$(document).on("click", "#import", function(e) {
    $("#importMenu").modal("show");
})

function getLocationsByAddress(addr) {
    $.ajax({
        type: 'GET',
        url: "http://maps.googleapis.com/maps/api/geocode/json",
        data: {address: addr, sensor: true},

        success: function (data) {
            console.log(data);

            lat = data.results[0].geometry.location.lat;
            lng = data.results[0].geometry.location.lng;
            address = data.results[0].formatted_address;
            console.log(address + ": "+ lat + "/" + lng);

            showLocationByLatLng(lat, lng, address);

        },
        error: function (data) {
            console.log("error");
            console.log(data);
        }
    });
}

function showLocationByLatLng(lat, lng, address) {
    var add;
    codeLatLng(lat, lng, function (addr) {
        add = addr;
    });

    console.log(add);
    handler = Gmaps.build('Google', { builders: { Marker: InfoBoxBuilder} });
    handler.buildMap({ provider: {maxZoom: 15}, internal: {id: 'map'}}, function () {


        markers = handler.addMarkers([
            {
                "lat": lat,
                "lng": lng,
                "picture": {
                    "url": "/assets/bulavka.png",
                    "width": 36,
                    "height": 36
                },


                "infowindow": "<div class=\"location\"><h1 style=\"color: #ffffff; font-size: 14px; margin-top: 35px\">" + address + "</h1></div>"
            }
        ]);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();

    });

    $("#map-loader .image").css("display", "none");

}

$(document).on("click", ".flash .close_button", function(e) {
    $(".flash").css("display", "none");
})


$(document).on("click", "#togle-buttons button", function() {
    $("#togle-buttons  button").removeClass("active");
    $(this).addClass("active");
});

