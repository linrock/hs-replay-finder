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
    legendStats: {},
    replays: [],
  },

  mutations: {
    hoverOverClass(state, className) {
      state.hover.class = className
    },
    setLegendStats(state, legendStats) {
      state.legendStats = legendStats
    },
    setQuery(state, query) {
      state.query = query
    },
    setReplays(state, replays) {
      state.replays = replays
    }
  },

  actions: {
    hoverOverClass({ commit }, className) {
      commit('hoverOverClass', className)
    },
    setLegendStats({ commit }, legendStats) {
      commit('setLegendStats', legendStats)
    },
    setQuery({ commit }, query) {
      if (!query.class) {
        commit('setQuery', { class: `any`, archetype: `any` })
      } else {
        commit('setQuery', query)
      }
    },
    setReplays({ commit }, replays) {
      commit('setReplays', replays)
    },
  },

  getters: {
    queryParams: state => ({
      class: state.query.class.toLowerCase(),
      archetype: state.query.archetype.toLowerCase(),
    })
  }
})

export default store
