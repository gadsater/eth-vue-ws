import Vue from "vue";
import App from "./App.vue";
import Vuex from "vuex";
import Buefy from "buefy";
import "buefy/dist/buefy.css";

// Todo: Update this when publishing
// import drizzleVuePlugin from '@drizzle/vue-plugin'
//
import drizzleVuePlugin from "@drizzle/vue-plugin";
import drizzleOptions from "./drizzleOptions";

Vue.use(Vuex);
const store = new Vuex.Store({ state: {} });

Vue.use(drizzleVuePlugin, { store, drizzleOptions });

Vue.config.productionTip = false;

Vue.use(Buefy);

new Vue({
  store,
  render: h => h(App)
}).$mount("#app");
