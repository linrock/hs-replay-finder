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
  .replay-link
    align-items center
    color #111
    display flex
    padding 8px 0
    text-decoration none
    width 510px

    &:hover
      background #fafafa
      opacity 0.7

    &:visited
      color #999
      opacity 0.7

  .player
    font-weight 500
    width 180px

  .player1
    text-align right

  .player2
    text-align left

  .vs
    text-align center
    width 50px

</style>
