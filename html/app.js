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
        MAP_LIST: {},
        SelectedDispatch: null,
    }),

    methods: {
        CreateMAP(key, id) {
            const CUSTOM_CRS = L.extend({}, L.CRS.Simple, {
                projection: L.Projection.LonLat,
                scale: function(zoom) { 
                    return Math.pow(1, zoom - 4);
                },
                zoom: function(sc) {
                    return Math.log(sc) / 0.6931471805599453;
                },
                transformation: new L.Transformation(0.02072, 117.3, -0.0205, 172.8),
                infinite: false
            });
            
            this.MAP_LIST[key] = L.map(id, {
                crs: CUSTOM_CRS,
                minZoom: 3,
                maxZoom: 7,
                noWrap: false,
                continuousWorld: false,
                preferCanvas: true,
            
                center: [0, -1024],
                zoom: 4,
            });  
            
            const MAP = this.MAP_LIST[key];

            const MAP_IMAGE = 'https://gta-assets.nopixel.net/images/dispatch-map.png';
            const SW = MAP.unproject([0, 1024], 3 - 1);
            const NE = MAP.unproject([1024, 0], 3 - 1);
            const MAP_BOUNDS = new L.LatLngBounds(SW, NE);
            MAP.setMaxBounds(MAP_BOUNDS);            

            MAP.attributionControl.setPrefix(false)

            L.imageOverlay(MAP_IMAGE, MAP_BOUNDS).addTo(MAP);

            MAP.on('drag', function() {
                MAP.panInsideBounds(MAP_BOUNDS, { animate: false });
            });
        },

        // DispatchMAP(DISPATCH) {
        //     const MIN = Math.round(Math.round((new Date() - new Date(DISPATCH.time)) / 1000) / 60);
        //     if (MIN > 10)
        //         return;

        //     Object.keys(this.MAP_LIST).forEach(key => {
        //         const value = this.MAP_LIST[key];

        //         const COORDS_X = DISPATCH.origin.x;
        //         const COORDS_Y = DISPATCH.origin.y;
        //         const CODE = DISPATCH.callId;

        //         const ICON_TYPE = this.DispatchPing;

        //         this.Dispatches[CODE] = L.marker([COORDS_Y, COORDS_X], { icon: ICON_TYPE });

        //         this.Dispatches[CODE].bindTooltip(`<div class="map-tooltip-info">${DISPATCH.dispatchMessage}</div><div class="map-tooltip-resp"><b>${Object.keys(DISPATCH.units).length}</b> units responding.</div><div class="map-tooltip-id">#${DISPATCH.callId}</div>`, {
        //             direction: 'top',
        //             permanent: false,
        //             offset: [0, -10],
        //             opacity: 1,
        //             interactive: true,
        //             className: 'map-tooltip'
        //         });

        //         this.Dispatches[CODE].addTo(value);
        //     });
        // },

        // ClearMap() {
        //     $(".leaflet-popup-pane").empty();
        //     $(".leaflet-marker-pane").empty();
        // }   

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
        this.CreateMAP("small", this.$refs.smallMap);

        setTimeout(() => {
            const map = this.MAP_LIST["small"];
            const bounds = map.getBounds();
            map.fitBounds(bounds, { animate: false });        
        }, 100);        
        
        window.addEventListener("message", event => {
            window.addEventListener('keyup', this.onKeyUp);
            switch (event.data.message) {
                case "OPEN":
                    this.Show = true
                break;
                
                case "CLOSE":
                    this.Show = false
                break;
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