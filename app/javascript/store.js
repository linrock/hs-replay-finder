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
    hoverOverClass({ commit, state }, className) {
      if ([`any`, className].includes(state.query.class)) {
        commit('hoverOverClass', className)
      }
    },
    setLegendStats({ commit }, legendStats) {
      commit('setLegendStats', legendStats)
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
    classes: state => state.legendStats.classes,
    queryParams: state => ({
      class: state.query.class.toLowerCase(),
      archetype: state.query.archetype.toLowerCase(),
    })
  }
})

export default store
