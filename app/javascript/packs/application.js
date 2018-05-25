/* eslint no-console: 0 */

import Vue from 'vue'
import VueRouter from 'vue-router'
import App from '../app.vue'

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
  new Vue({
    render: h => h(App),
    router,
  }).$mount('#vue-app')
})


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>

// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
