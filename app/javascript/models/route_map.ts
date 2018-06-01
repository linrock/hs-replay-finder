interface Route {
  class?: string;
  archetype?: string;
  winrate?: string;
}

export default class RouteMap {

  constructor(public routeMap: { [path: string]: Route }) {
    this.routeMap = routeMap
  }

  get classArray(): Array<[string, Route]> {
    return Object.entries(this.routeMap)
      .filter(r => !r[1].archetype)
      .sort((a,b) => parseFloat(a[1].winrate) - parseFloat(b[1].winrate))
  }

  classArchetypeRows(className): Array<[string, Route]> {
    return Object.entries(this.routeMap)
      .filter(r => r[1].class === className && r[1].archetype)
      .sort((a,b) => parseFloat(a[1].winrate) - parseFloat(b[1].winrate))
  }

  classArchetypes(className): Array<Route> {
    return Object.values(this.routeMap)
      .filter(r => r.class === className && r.archetype)
      .sort((a,b) => parseFloat(a.winrate) - parseFloat(b.winrate))
  }

  getRoute(path): Route {
    return this.routeMap[path.replace(/^\//, '')] || {}
  }
}
