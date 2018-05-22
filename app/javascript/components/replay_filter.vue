<template lang="pug">
  .replay-filter
    .filter
      .label class
      select(v-model="selectedClass")
        option any
        option Rogue
        option Shaman
        option Paladin

    .filter
      .label archetype
      select(v-model="selectedArchetype")
        option any
        option Odd

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
          class: this.selectedClass,
          archetype: this.selectedArchetype,
          outcome: this.selectedOutcome,
        }
      }
    },

    watch: {
      query(newQuery, oldQuery) {
        console.log(`query changed: ${JSON.stringify(newQuery)}`)
        this.store.query = newQuery
        this.fetchReplays()
      },
    },

    methods: {
      fetchReplays() {
        return fetchReplays(this.query).then(data => {
          console.log(`${data.replays.length} replays found`)
          this.store.replays = data.replays
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
