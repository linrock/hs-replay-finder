<template lang="pug">
  .replay-row
    a.replay-link(:href="replay.link" target="_blank")
      span.player.player1 {{ replay.p1.archetype }}
      player-rank(:player="replay.p1" :winner="replay.winner === `p1`")
      span.vs vs
      player-rank(:player="replay.p2" :winner="replay.winner === `p2`")
      span.player.player2 {{ replay.p2.archetype }}

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
    padding 10px 0
    text-decoration none
    width 510px
    border-radius 2px

    &:hover
      background #fafafa
      opacity 1

    &:visited
      color #999
      opacity 0.7

  .player
    width 180px

  .player1
    text-align right

  .player2
    text-align left

  .vs
    text-align center
    width 50px
    font-weight 300
    opacity 0.5

</style>
