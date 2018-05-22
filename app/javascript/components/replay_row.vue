<template>
  <div class="replay-row">
    <a :href="replay.link" class="replay-link" target="_blank">
      <span class="player player1">{{ replay.p1.archetype }}</span>
      <player-rank :player="replay.p1"/>
      <span class="vs">vs.</span>
      <player-rank :player="replay.p2"/>
      <span class="player player2">{{ replay.p2.archetype }}</span>
    </a>
  </div>
</template>

<script>
  import PlayerRank from "./player_rank"

  export default {
    props: {
      replay: {
        required: true,
      },
    },

    components: {
      PlayerRank,
    }
  }
</script>

<style lang="stylus" scoped>

</style>
