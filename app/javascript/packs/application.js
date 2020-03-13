import "bootstrap";
import "nouislider";
import "components/slider";
import "components/navbar";
import "components/distance";
import "components/priceRange";
import "components/categoriesFade";
import { algoliaSearch } from "../plugins/places.js.erb";
algoliaSearch();

import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!

import { initMapbox } from '../plugins/init_mapbox';

initMapbox();

import "components/btn-category"

import { loadPageHeader } from "../plugins/loading-type";
loadPageHeader();
