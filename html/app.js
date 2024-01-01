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

        DisableScroll() {
            window.addEventListener("wheel", this.preventScroll, { passive: false });
        },

        EnableScroll() {
            window.removeEventListener("wheel", this.preventScroll);
        },
    },

    computed: {
        
    },

    watch: {
    
    },

    beforeDestroy() {
        window.removeEventListener('keyup', this.onKeyUp);
    },

    mounted() {  
        const center_x = 117.3;
        const center_y = 172.8;
        const scale_x = 0.02072;
        const scale_y = 0.0205;

        CUSTOM_CRS = L.extend({}, L.CRS.Simple, {
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
            transformation: new L.Transformation(scale_x, center_x, -scale_y, center_y),
            infinite: true
        });

        var AtlasStyle	= L.tileLayer('mapStyles/styleAtlas/{z}/{x}/{y}.jpg', {minZoom: 0,maxZoom: 5,noWrap: true,continuousWorld: false,id: 'styleAtlas map',});

        var ExampleGroup = L.layerGroup();

        var Icons = {
            "Example": ExampleGroup,
        };

        var mymap = L.map('map', {
            crs: CUSTOM_CRS,
            minZoom: 2,
            maxZoom: 5,
            Zoom: 5,
            maxNativeZoom: 5,
            preferCanvas: true,
            layers: [AtlasStyle],
            center: [0, 0],
            zoom: 3,
        });

        function customIcon(icon){
            return L.icon({
                iconUrl: `img/police.png`,
                iconSize:     [35, 35],
                iconAnchor:   [20, 20], 
                popupAnchor:  [-10, -27]
            });
        }

        var X  = 0;
        var Y = 0;
        ExampleGroup.clearLayers();

        L.marker([Y, X], { icon: customIcon() }).bindPopup("I am here.").addTo(mymap);

        window.addEventListener("message", event => {
            const data = event.data;
            
            if (data.action == 'albakim') {
                this.Show = true
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