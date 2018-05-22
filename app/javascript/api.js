import axios from 'axios'

function buildQueryString(query) {
  return Object.keys(query).map(key => `${key}=${query[key]}`.toLowerCase()).join("&")
}

export default function fetchReplays(query) {
  return axios.get(`replays.json?${buildQueryString(query)}`).then(response => {
    if (response.status === 200) {
      return response.data
    } else {
      console.error('api request failed')
    }
  })
}
