import Vue from 'vue'
import Vuex from 'vuex'

import Replays from './models/replays'
import RouteMap from './models/route_map'
import AboutWinrates from './models/about_winrates'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    path: `/`,
    filter: `all`,
    page: 1,
    hoverClassName: null,
    aboutWinrates: {},
    routeMap: {},
    replays: new Replays(),
    replayFeedTitle: ``,
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
    setFilterOption(state, filter) {
      state.filter = filter
    },
    setReplays(state, replays) {
      state.replays = new Replays()
      state.replays.addReplays(replays)
    },
    addReplays(state, replays) {
      state.replays.addReplays(replays)
    },
    setReplayFeedTitle(state, replayFeedTitle) {
      state.replayFeedTitle = replayFeedTitle
    },
    setPage(state, page) {
      state.page = page
    }
  },

  actions: {
    hoverOverClassImage({ commit, getters }, path) {
      const className = path ? getters.routeMap(path).class : null
      commit(`hoverOverClassName`, className)
    },
    setInitialData({ commit }, initialData) {
      commit(`setRouteMap`, new RouteMap(initialData.routeMap))
      commit(`setAboutWinrates`, new AboutWinrates(initialData.aboutWinrates))
    },
    setPath({ commit, dispatch, getters }, path) {
      const route = getters.routeMap(path)
      if (route.class && !route.archetype) {
        dispatch(`hoverOverClassImage`, path)
      }
      commit(`setPath`, path || `/`)
    },
    setFilterOption({ commit }, filter) {
      commit(`setFilterOption`, filter)
    },
    setReplays({ commit, getters, state }, replays) {
      commit(`setReplays`, replays)
    },
    setReplayFeedTitle({ commit, state }, route) {
      let replayFeedTitle
      if (!route.archetype) {
        replayFeedTitle = !route.class ? `Recent replays` : route.class
      } else {
        replayFeedTitle = `${route.archetype} ${route.class}`
      }
      if (state.filter === `top100`) {
        replayFeedTitle = `Top 100 - ${replayFeedTitle}`
      } else if (state.filter === `top1000`) {
        replayFeedTitle = `Top 1000 - ${replayFeedTitle}`
      }
      commit(`setReplayFeedTitle`, replayFeedTitle)
    },
    addReplays({ commit }, replays) {
      commit(`addReplays`, replays)
    },
    setPage({ commit }, page) {
      commit(`setPage`, page)
    }
  },

  getters: {
    numReplays: state => state.aboutWinrates.numReplays,
    sinceDays: state => state.aboutWinrates.sinceDays,
    classArray: state => state.routeMap.classArray,
    classArchetypeRows: state => className => state.routeMap.classArchetypeRows(className),
    currentRoute: (state, getters) => getters.routeMap(state.path),
    currentPage: state => state.page,
    routeMap: state => path => state.routeMap.getRoute(path),
    replays: state => state.replays.replayList,
  }
})

export default store
