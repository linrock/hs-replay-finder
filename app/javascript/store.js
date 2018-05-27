import Vue from 'vue'
import Vuex from 'vuex'

import RouteMap from './models/route_map'
import AboutWinrates from './models/about_winrates'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    path: `/`,
    hoverClassName: null,
    aboutWinrates: {},
    routeMap: {},
    replays: [],
  },

  mutations: {
    hoverOverClassName(state, className) {
      state.hoverClassName = className
    },
    setAboutWinrates(state, aboutWinrates) {
      state.aboutWinrates = aboutWinrates
    },
    setRouteMap(state, routeMap) {
      state.routeMap = routeMap
    },
    setPath(state, path) {
      state.path = path
    },
    setReplays(state, replays) {
      state.replays = replays
    }
  },

  actions: {
    hoverOverClassImage({ commit, getters }, path) {
      const className = path ? getters.routeMap(path).class : null
      commit('hoverOverClassName', className)
    },
    setInitialData({ commit }, initialData) {
      commit('setRouteMap', new RouteMap(initialData.routeMap))
      commit('setAboutWinrates', new AboutWinrates(initialData.aboutWinrates))
    },
    setPath({ commit, dispatch, getters }, path) {
      const route = getters.routeMap(path)
      if (route.class && !route.archetype) {
        dispatch(`hoverOverClassImage`, path)
      }
      commit('setPath', path || `/`)
    },
    setReplays({ commit }, replays) {
      commit('setReplays', replays)
    },
  },

  getters: {
    numReplays: state => state.aboutWinrates.numReplays,
    sinceDays: state => state.aboutWinrates.sinceDays,
    classArray: state => state.routeMap.classArray,
    classArchetypeRows: state => className => state.routeMap.classArchetypeRows(className),
    currentRoute: (state, getters) => getters.routeMap(state.path),
    routeMap: state => path => state.routeMap.getRoute(path),
  }
})

export default store
