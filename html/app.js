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
        players: {},
        SelectedDispatch: null,
        map: null,
        mapMarkers: null, 
        dispatchPing: null
    }),

    methods: {    
        dispatchMap(playersData) {
            playersData.forEach(playerInfo => {
                const playerId = playerInfo.id;
                const playerCoords = { x: playerInfo.x, y: playerInfo.y };
    
                // Oyuncu zaten varsa, mevcut marker'ı güncelle
                if (this.players[playerId]) {
                    const existingMarker = this.players[playerId].marker;
                    existingMarker.setLatLng([playerCoords.y, playerCoords.x]);
                    return;
                }
    
                // Yeni bir marker oluştur ve haritaya ekle
                const newMarker = L.marker([playerCoords.y, playerCoords.x], { icon: this.dispatchPing });
                newMarker.addTo(this.map);
    
                // Oyuncu bilgilerini table'a ekle
                this.players[playerId] = { coords: playerCoords, marker: newMarker };
    
    
                // Tooltip ayarla
                newMarker.bindTooltip(`<div class="map-tooltip-info">Oyuncu #${playerId}</div>`, {
                    direction: 'top',
                    permanent: false,
                    offset: [0, -10],
                    opacity: 1,
                    interactive: true,
                    className: 'map-tooltip'
                });
    
                // Marker'a tıklama olayını ekle
                newMarker.on('click', () => {
                    // Oyuncuya tıklanınca yapılacak işlemleri buraya ekleyebilirsiniz
                    // Örneğin, bir HTTP isteği gönderme gibi
                });
            });
        },

        clearMap() {
            this.$refs.mapClear.innerHTML = '<span class="fas fa-spinner fa-spin"></span>';
            setTimeout(() => {
                this.$refs.mapClear.innerHTML = 'Clear';
            }, 1500);
        },

        CreateMap() {
            const customcrs = L.extend({}, L.CRS.Simple, {
                projection: L.Projection.LonLat,
                scale: zoom => Math.pow(2, zoom),
                zoom: sc => Math.log(sc) / 0.6931471805599453,
                distance: (pos1, pos2) => {
                    const x_difference = pos2.lng - pos1.lng;
                    const y_difference = pos2.lat - pos1.lat;
                    return Math.sqrt(x_difference * x_difference + y_difference * y_difference);
                },
                transformation: new L.Transformation(0.02072, 117.3, -0.0205, 172.8),
                infinite: false,
            });
    
            this.map = L.map("map-item", {
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
    
            const customImageUrl = 'https://gta-assets.nopixel.net/images/dispatch-map.png';
            const sw = this.map.unproject([0, 1024], 3 - 1);
            const ne = this.map.unproject([1024, 0], 3 - 1);
            const mapbounds = new L.LatLngBounds(sw, ne);
    
            this.map.setView([-300, -1500], 4);
            this.map.setMaxBounds(mapbounds);
    
            L.imageOverlay(customImageUrl, mapbounds).addTo(this.map);
    
            this.map.attributionControl.setPrefix(false);
    
            this.map.on('dragend', () => {
                if (!mapbounds.contains(this.map.getCenter())) {
                    this.map.panTo(mapbounds.getCenter(), { animate: false });
                }
            });
    
            // Leaflet icon ve layerGroup ayarları
            this.dispatchPing = L.divIcon({
                html: '<img src="img/police.png" class="map-icon" />',
                iconSize: [20, 20],
                className: 'map-icon-ping',
                iconAnchor: [10, 20]
            });
    
            this.mapMarkers = L.layerGroup();
            this.map.addLayer(this.mapMarkers);
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
                    this.CreateMap()
                    this.dispatchMap(data.data)
                }, 10)
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