<template lang="pug">
  .replay-filter
    .instructions
      | Find replays and stats of games
      | by legend-rank players. Choose
      | a class and archetype to filter
      | the list.
    class-selector
    class-stats

</template>

<script>
  import fetchReplays from '../api'
  import { store } from '../store'
  import ClassSelector from './class_selector'
  import ClassStats from "./class_stats"

  // depends on a global window.archetypes

  export default {
    data() {
      return {
        selectedClass: `any`,
        selectedArchetype: `any`,
        selectedOutcome: `any`,
        store,
      }
    },

    created() {
      this.fetchReplays()
    },

    computed: {
      query() {
        return {
          class: store.query.class,
          archetype: store.query.archetype,
          outcome: this.selectedOutcome,
        }
      },
      archetypes() {
        return window.archetypes[this.selectedClass] || []
      },
    },

    watch: {
      query(newQuery, oldQuery) {
        console.log(`query changed: ${JSON.stringify(newQuery)}`)
        this.fetchReplays()
      },
      selectedClass(newSelectedClass) {
        this.selectedArchetype = 'any'
      },
    },

    methods: {
      fetchReplays() {
        return fetchReplays(this.query).then(data => {
          console.log(`${data.replays.length} replays found`)
          this.store.replays = data.replays
          const meta = {
            count: data.meta.count
          }
          if (data.meta.winrate) {
            meta.winrate = data.meta.winrate
          }
          console.log(JSON.stringify(meta))
          this.store.meta = meta
        })
      },
    },

    components: {
      ClassSelector,
      ClassStats,
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-filter
    position fixed
    left 50px
    top 65px

    .instructions
      font-size 14px
      line-height 20px
      width 240px
      margin-bottom 30px

</style>
