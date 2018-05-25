import { classPath } from '../utils'

export default class ReplayStats {

  constructor(stats) {
    this.stats = stats
  }

  get meta() {
    return this.stats.meta
  }

  get classStats() {
    return this.stats.classes
  }

  // sorted by winrate
  get classNames() {
    return Object.entries(this.classStats)
      .sort((a,b) => parseFloat(b[1].winrate) - parseFloat(a[1].winrate))
      .map(row => row[0])
  }

  get routeMap() {
    const map = {}
    Object.entries(this.classStats).forEach(([className, classData]) => {
      map[classPath(className)] = {
        class: className,
        archetype: `any`,
      }
      Object.keys(classData.archetypes).forEach(archetypeName => {
        map[classPath(className, archetypeName)] = {
          class: className,
          archetype: archetypeName,
        }
      })
    })
    return map
  }

  // sorted by winrate
  classArchetypes(className) {
    if (className === `any`) {
      return []
    }
    return Object.entries(this.classStats[className].archetypes)
      .sort((a,b) => parseFloat(b[1]) - parseFloat(a[1]))
      .map(row => ({ name: row[0], winrate: row[1] }))
  }
}
