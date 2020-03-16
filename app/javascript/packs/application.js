import "bootstrap";
import "nouislider";
import "components/slider";
import "components/navbar";
import "components/distance";
import "components/priceRange";
import "components/btn-category";
import "components/categoriesFade";
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { initMapbox } from '../plugins/init_mapbox';
import { loadPageHeader } from "../plugins/loading-type";
import { algoliaSearch } from "../plugins/places.js.erb";
initMapbox();
algoliaSearch();
loadPageHeader();


