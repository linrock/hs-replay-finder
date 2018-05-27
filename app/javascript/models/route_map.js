export default class RouteMap {

  constructor(routeMap) {
    this.routeMap = routeMap
  }

  get classArray() {
    return Object.entries(this.routeMap)
      .filter(r => !r[1].archetype)
      .sort((a,b) => parseFloat(a[1].winrate) < parseFloat(b[1].winrate))
  }

  get classNames() {
    return Object.values(this.classArray).map(a => a.class)
  }

  classArchetypeRows(className) {
    return Object.entries(this.routeMap)
      .filter(r => r[1].class === className && r[1].archetype)
      .sort((a,b) => parseFloat(a[1].winrate) < parseFloat(b[1].winrate))
  }

  classArchetypes(className) {
    return Object.values(this.routeMap)
      .filter(r => r.class === className && r.archetype)
      .sort((a,b) => parseFloat(a.winrate) < parseFloat(b.winrate))
  }

  getRoute(path) {
    return this.routeMap[path.replace(/^\//, '')] || {}
  }
}
