/* eslint no-console: 0 */

import Vue from 'vue'
import VueRouter from 'vue-router'
import App from '../app'

Vue.use(VueRouter)

const mountBasePath = pathname => {
  const match = pathname.match(/^\/([^/]+)\//)
  return match ? match[0] : `/`
}

const router = new VueRouter({
  mode: 'history',
  base: mountBasePath(window.location.pathname),
  routes: [
    {
      path: '/:path',
      component: App,
    }
  ]
})

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('main'))
  new Vue({
    render: h => h(App),
    router,
    el,
  })
})
