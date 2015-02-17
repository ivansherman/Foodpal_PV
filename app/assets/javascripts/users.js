$(document).on("shown.bs.tab", "a[data-toggle='tab']", function(e) {
    console.log("  => on tab change action");
    console.log("   -> " + e.target.href);
    if (e.target == $('a[href="#edit"]')[0]) {
        selectUserState(this);
    }

});

$(document).on("ready",  function() {
    console.log("loading");
    selectUserState($("#user_id"));
})

function selectUserState(t) {
    console.log("  => select user state [/users/get_user_state]");
    console.log(t);
    console.log($(t).val());

    $.ajax({
        url: '/users/get_user_state',
        type: 'GET',
        data: {id: $(t).val()},
        success: function(data){
            if (data) {
                $("#state option[value=" + data["id"] + "]").attr("selected", "selected");
                selectState("#state select");
                selectUserCity("#city select");
            }

        },
        error: function(data){
            console.log('error------------------------------');
            console.log(data)

        }

    })
}

function selectUserCity(t) {
    console.log("  => select user city [/users/get_user_city]");

    $.ajax({
        url: '/users/get_user_city',
        type: 'GET',
        data: {id: $(t).val()},
        success: function(data){

            if (data) {
                $("#city option[value=" + data["id"] + "]").attr("selected", "selected");
            }



        },
        error: function(data){
            console.log('error------------------------------');
            console.log(data)

        }

    })
}


$(document).on("change", "#edit #state select", function() {
    console.log("  => on state edit state select ");
    selectState(this);
});

function selectState(t) {
    console.log("  => select state [/users/get_state]");

    $.ajax({
        url: '/users/select_state',
        type: 'GET',
        data: {id: $(t).val()},
        success: function(data){
            answer = data;
            $('#city').css('display','block');
            options = '';
            for(i in data){
              options += '<option value="'+data[i]['id']+'">'+data[i]['city']+'</option>';

            }
            $('#city select').html(options);


        },
        error: function(data){
            console.log('error------------------------------');
            console.log(data)

        }

    })
}



