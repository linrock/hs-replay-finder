<template lang="pug">
  .replay-filter
    .filter
      .label class
      select(v-model="selectedClass")
        option any
        option(v-for="className in classes") {{ className }}

    .filter
      .label archetype
      select(v-model="selectedArchetype")
        option any
        option(v-for="archetype in archetypes") {{ archetype }}

    .filter
      .label outcome
      select(v-model="selectedOutcome")
        option any
        option Win
        option Loss

    .filter
      .label rank
      .select Legend

</template>

<script>
  import fetchReplays from '../api'
  import { store } from '../store'

  // depends on a global window.archetypes

  export default {
    data() {
      return {
        selectedClass: `any`,
        selectedArchetype: `any`,
        selectedOutcome: `any`,
        classes: Object.keys(window.archetypes).sort(),
        store,
      }
    },

    created() {
      this.fetchReplays()
    },

    computed: {
      query() {
        return {
          class: this.selectedClass,
          archetype: this.selectedArchetype,
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
        this.store.query = newQuery
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
  }
</script>

<style lang="stylus" scoped>
  .replay-filter
    position fixed
    left 50px
    top 65px

    .filter
      display flex
      margin 5px 0

      .label
        width 100px

</style>
