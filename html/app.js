const store = Vuex.createStore({
    state: {},
    mutations: {},
    actions: {}
});

const app = Vue.createApp({
    data: () => ({
        Show: false,
        Dispatches: [
            {id: 1, crime: 'Shooting!', time: '10:28 AM', info: {location: 'Alta Street', gender: 'Male', weapon: 'Pistol', vehiclestatus: 'On foot', plate: 'None', vehiclecolor: 'None'}, claimed: true},
            {id: 2, crime: 'Shooting!', time: '10:32 AM', info: {location: 'Capital Boulevard', gender: 'Female', weapon: 'AK-47', vehiclestatus: 'Sultan RS', plate: 'ABC3122', vehiclecolor: 'Red'}, claimed: false}
        ],
        SelectedDispatch: null,
        MapID: null,
        group: null
    }),

    methods: {
        DisableScroll() {
            window.addEventListener("wheel", this.preventScroll, { passive: false });
        },

        EnableScroll() {
            window.removeEventListener("wheel", this.preventScroll);
        },

        EnableLeaflet(data) {
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

            for (const key in data) {
                if (data.hasOwnProperty(key)) {
                    const player = data[key];
                    const { playername, id, playerx, playery } = player;
        
                    function customIcon() {
                        return L.icon({
                            iconUrl: `img/police.png`,
                            iconSize: [35, 35],
                            iconAnchor: [20, 20],
                            popupAnchor: [-10, -27]
                        });
                    }
        
                    L.marker([playery, playerx], { icon: customIcon() }).bindPopup(playername).addTo(ExampleGroup);
                }
            }
            mymap.addLayer(ExampleGroup)

            this.MapID = mymap
            this.group = ExampleGroup
        },

        UpdateLoc(x, y, heading) {
            if (this.Show) {
                if (this.MapID) {
                    if (this.group) {
                        if (this.MapID.hasLayer(this.group)) {
                            const currentmarker = this.group.getLayers()[0];
        
                            if (currentmarker) {
                                currentmarker.setLatLng([y, x]).update();
                            } else {
                                function customIcon(){
                                    return L.icon({
                                        iconUrl: `img/police.png`,
                                        iconSize:     [35, 35],
                                        iconAnchor:   [20, 20], 
                                        popupAnchor:  [-10, -27],
                                        rotationAngle: heading,
                                    });
                                }

                                L.marker([y, x], { icon: customIcon() }).bindPopup("I am here.").addTo(this.group);
                            }
                        }
                    }
                }
            }
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
        window.addEventListener("message", event => {
            const data = event.data;
            
            if (data.action == 'OpenUI') {
                this.Show = true
                setTimeout(() => {
                    this.EnableLeaflet(data.data)
                }, 100)
            }

            if (data.action == 'UpdateLoc') {
                setTimeout(() => {
                    this.UpdateLoc(data.x, data.y, data.heading)
                }, 100)
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