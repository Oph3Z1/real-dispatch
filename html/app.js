const store = Vuex.createStore({
    state: {},
    mutations: {},
    actions: {}
});

const app = Vue.createApp({
    data: () => ({
        Show: true,
        Dispatches: [
            {id: 1, crime: 'Shooting!', time: '10:28 AM', info: {location: 'Alta Street', gender: 'Male', weapon: 'Pistol', vehiclestatus: 'On foot', plate: 'None', vehiclecolor: 'None'}, claimed: true},
            {id: 2, crime: 'Shooting!', time: '10:32 AM', info: {location: 'Capital Boulevard', gender: 'Female', weapon: 'AK-47', vehiclestatus: 'Sultan RS', plate: 'ABC3122', vehiclecolor: 'Red'}, claimed: false}
        ],
        SelectedDispatch: null,
    }),

    methods: {    
        
    },

    computed: {
        
    },

    watch: {
    
    },

    beforeDestroy() {
        window.removeEventListener('keyup', this.onKeyUp);
    },

    mounted() { 
        window.addEventListener("message", event => {
            const data = event.data;
            
            if (data.action == 'OpenUI') {
            }

            if (data.action == 'UpdateLoc') {
            }
        });
    },      
});

app.use(store).mount("#app");

const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : "hog-PauseMenu";

window.postNUI = async (name, data) => {
    try {
        const response = await fetch(`https://${resourceName}/${name}`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            redirect: "follow",
            referrerPolicy: "no-referrer",
            body: JSON.stringify(data)
        });
        return !response.ok ? null : response.json();
    } catch (error) {
        // console.log(error)
    }
};

customcrs = L.extend({}, L.CRS.Simple, {
    projection: L.Projection.LonLat,
    scale: function(zoom) {
  
        return Math.pow(2, zoom);
    },
    zoom: function(sc) {
  
        return Math.log(sc) / 0.6931471805599453;
    },
    distance: function(pos1, pos2) {
        var x_difference = pos2.lng - pos1.lng;
        var y_difference = pos2.lat - pos1.lat;
        return Math.sqrt(x_difference * x_difference + y_difference * y_difference);
    },
    transformation: new L.Transformation(0.02072, 117.3, -0.0205, 172.8),
    infinite: false
});
  
var map = L.map("map-item", {
    crs: customcrs,
    minZoom: 3,
    maxZoom: 5,
    zoom: 5,
    
    noWrap: true,
    continuousWorld: false,
    preferCanvas: true,
    
    center: [0, -1024],
    maxBoundsViscosity: 1.0
});
    
var customImageUrl = 'https://gta-assets.nopixel.net/images/dispatch-map.png';

var sw = map.unproject([0, 1024], 3 - 1);
var ne = map.unproject([1024, 0], 3 - 1);
var mapbounds = new L.LatLngBounds(sw, ne);
map.setView([-300, -1500], 4);
map.setMaxBounds(mapbounds);


map.attributionControl.setPrefix(false)
L.imageOverlay(customImageUrl, mapbounds).addTo(map);

map.on('dragend', function() {
    if (!mapbounds.contains(map.getCenter())) {
        map.panTo(mapbounds.getCenter(), { animate: false });
    }
});

var Dispatches = {};
var DispatchPing = L.divIcon({
  html: '<i class="fa fa-location-dot fa-2x"></i>',
  iconSize: [20, 20],
  className: 'map-icon map-icon-ping',
  offset: [-10, 0]
});
var mapMarkers = L.layerGroup();
  
function DispatchMAP(DISPATCH) {
    var MIN = Math.round(Math.round((new Date() - new Date(DISPATCH.time)) / 1000) / 60);
    if (MIN > 10) return;
  
    var COORDS_X = DISPATCH.origin.x
    var COORDS_Y = DISPATCH.origin.y
    var CODE = DISPATCH.callId
  
    Dispatches[CODE] = L.marker([COORDS_Y, COORDS_X], { icon: DispatchPing });
    Dispatches[CODE].addTo(map);
  
    // Automatic deletion after a period of 20 minutes, equivalent to 1200000 milliseconds.
    setTimeout(function() {
      map.removeLayer(Dispatches[CODE]);
    }, 1200000);
    
    Dispatches[CODE].bindTooltip(`<div class="map-tooltip-info">${DISPATCH.dispatchMessage}</div></div><div class="map-tooltip-id">#${DISPATCH.callId}</div>`,
        {
            direction: 'top',
            permanent: false,
            offset: [0, -10],
            opacity: 1,
            interactive: true,
            className: 'map-tooltip'
        });

    Dispatches[CODE].addTo(mapMarkers);

    Dispatches[CODE].on('click', function() {
        const callId = CODE
        $.post(
            `https://${GetParentResourceName()}/setWaypoint`,
            JSON.stringify({
                callid: callId,
            })
        );
    });

    Dispatches[CODE].on('contextmenu', function() {
        map.removeLayer(Dispatches[CODE]);
    });

}

function ClearMap() {
$(".leaflet-popup-pane").empty();
$(".leaflet-marker-pane").empty();
}

$(".map-clear").on('click', function() {
    $(".map-clear").empty();
    $(".map-clear").prepend(
      `<span class="fas fa-spinner fa-spin"></span>`
    );
    setTimeout(() => {
      $(".map-clear").empty();
      $(".map-clear").html("Clear");
      ClearMap();
    }, 1500);
});