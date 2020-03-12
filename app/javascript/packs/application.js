import "bootstrap";
import "components/navbar";
import "nouislider";
import "components/slider";
import "components/priceRange";
import "components/categoriesFade";
import "components/distance";
import { algoliaSearch } from "../plugins/places.js.erb";
algoliaSearch();

import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!

import { initMapbox } from '../plugins/init_mapbox';

initMapbox();

import "components/btn-category"
