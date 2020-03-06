import "bootstrap";
import "components/navbar";
import "nouislider";
import { slider } from "../components/slider.js";
import { algoliaSearch } from "../plugins/places.js.erb";
slider();
algoliaSearch();

