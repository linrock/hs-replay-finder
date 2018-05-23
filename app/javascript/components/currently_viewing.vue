<template lang="pug">
  .currently-viewing {{ currentlyViewing }}

</template>

<script>
  import { store } from '../store'

  export default {
    data() {
      return { store }
    },

    computed: {
      currentlyViewing() {
        const archetype = store.query.archetype
        const className = store.query.class
        if (archetype === `any` && className === `any`) {
          return `Recent replays`
        } else if (store.query.archetype === `any`) {
          return className
        } else {
          return `${archetype} ${className}`
        }
      },
      replays() {
        return this.store.replays
      }
    },
  }
</script>

<style lang="stylus" scoped>
  .currently-viewing
    margin-left 350px
    margin-top 21px 
    width 510px
    text-align center
    padding-bottom 15px
    border-bottom 1px solid #f0f0f0
    margin-bottom 10px

</style>
