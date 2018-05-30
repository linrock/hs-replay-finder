<template lang="pug">
  .rank-filter
    div Show me:
    select(v-model="selected").needsclick
      option(disabled name="") games played by
      option(value="all") all legend players
      option(value="top1000") top 1000 players
      option(value="top100") top 100 players

</template>

<script>
  export default {
    data() {
      return {
        selected: `all`
      }
    },

    watch: {
      selected() {
        this.$store.dispatch(`setFilterOption`, this.selected)
      }
    }
  }
</script>

<style lang="stylus">
  .rank-filter
    display flex
    align-items center
    font-size 14px
    margin-bottom 25px

    select
      margin-left 10px

</style>
