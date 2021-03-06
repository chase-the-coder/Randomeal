import mapboxgl from 'mapbox-gl';
const mapElement = document.getElementById('map');
const buildMap = () => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v10'
  });
};
const addMarkersToMap = (map, markers) => {
  const popup = new mapboxgl.Popup().setHTML(markers.infoWindow);
  new mapboxgl.Marker()
    .setLngLat([ markers.lng, markers.lat ])
    .setPopup(popup)
    .addTo(map);
};
const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  bounds.extend([ markers.lng, markers.lat ]);
  map.fitBounds(bounds, { zoom: 15, padding: 10, maxZoom: 25 });
};
const initMapbox = () => {
  if (mapElement) {
    const map = buildMap();
    const markers = JSON.parse(mapElement.dataset.markers);
    addMarkersToMap(map, markers);
    fitMapToMarkers(map, markers);
  }
};
export { initMapbox };
