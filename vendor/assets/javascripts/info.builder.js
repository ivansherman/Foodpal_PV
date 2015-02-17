var InfoBoxBuilder,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

InfoBoxBuilder = (function(_super) {

    __extends(InfoBoxBuilder, _super);

    function InfoBoxBuilder() {
        return InfoBoxBuilder.__super__.constructor.apply(this, arguments);
    }

    InfoBoxBuilder.prototype.create_infowindow = function() {
        var boxText;
        if (!_.isString(this.args.infowindow)) {
            return null;
        }
        boxText = document.createElement("div");
        boxText.setAttribute("class", 'infobox');
        boxText.innerHTML = this.args.infowindow;
        return this.infowindow = new InfoBox(this.infobox(boxText));
    };

    InfoBoxBuilder.prototype.infobox = function(boxText) {
        return {
            content: boxText,
            pixelOffset: new google.maps.Size(-90, -140),
            boxStyle: {
                width: "300px",
                height: "120px"

            },
            closeBoxMargin: "5px 10px 2px 2px",
            closeBoxURL: "/assets/w-close.png",

        };
    };

    return InfoBoxBuilder;

})(Gmaps.Google.Builders.Marker);