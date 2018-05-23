<template lang="pug">
  main#app
    section#sidebar
      replay-filter
    section#replays
      replay-list
      replay-timestamps

</template>

<script>
  import { store } from './store'
  import fetchReplays from './api'
  import ReplayFilter from './components/replay_filter'
  import ReplayList from './components/replay_list'
  import ReplayTimestamps from './components/replay_timestamps'

  export default {
    data() {
      return { store }
    },

    created() {
      this.fetchReplays()
    },

    methods: {
      fetchReplays() {
        return fetchReplays(this.query).then(data => {
          console.log(`${data.replays.length} replays found`)
          this.store.replays = data.replays
        })
      },
    },

    computed: {
      query() {
        return {
          class: store.query.class,
          archetype: store.query.archetype,
        }
      },
    },

    watch: {
      query(newQuery, oldQuery) {
        console.log(`query changed: ${JSON.stringify(newQuery)}`)
        this.fetchReplays()
      },
    },

    components: {
      ReplayFilter,
      ReplayList,
      ReplayTimestamps,
    },
  }
</script>

<style lang="stylus" scoped>
  #replays
    display flex

</style>
