import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    query: {
      class: `any`,
      archetype: `any`,
    },
    hover: {
      class: null,
    },
    replayStats: {},
    replays: [],
  },

  mutations: {
    hoverOverClass(state, className) {
      state.hover.class = className
    },
    setReplayStats(state, replayStats) {
      state.replayStats = replayStats
    },
    setQuery(state, query) {
      state.query = query
    },
    setReplays(state, replays) {
      state.replays = replays
    }
  },

  actions: {
    hoverOverClass({ commit, state }, className) {
      if ([`any`, className].includes(state.query.class)) {
        commit('hoverOverClass', className)
      }
    },
    setReplayStats({ commit }, replayStats) {
      commit('setReplayStats', replayStats)
    },
    setQuery({ commit }, query) {
      if (!query.class) {
        commit('setQuery', { class: `any`, archetype: `any` })
      } else {
        commit('setQuery', query)
        if (query.class !== `any`) {
          commit('hoverOverClass', query.class)
        }
      }
    },
    setReplays({ commit }, replays) {
      commit('setReplays', replays)
    },
  },

  getters: {
    aboutWinrates: state => state.replayStats.meta,
    classNames: state => state.replayStats.classNames,
    classStats: state => state.replayStats.classStats,
    classArchetypes: state => state.replayStats.classArchetypes,
    routeMap: state => state.replayStats.routeMap,
    queryParams: state => ({
      class: state.query.class.toLowerCase(),
      archetype: state.query.archetype.toLowerCase(),
    })
  }
})

export default store
