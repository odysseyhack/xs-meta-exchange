import Vue from 'vue'
import './plugins/vuetify'
import App from './App.vue'
import router from './router'
import store from './store'
import './registerServiceWorker'
import 'roboto-fontface/css/roboto/roboto-fontface.css'
import '@fortawesome/fontawesome-free/css/all.css'
import Web3 from 'web3'

Vue.config.productionTip = false

window.addEventListener('load', async () => {
    if (window.ethereum) {
        window.web3 = new Web3(window.ethereum)
        try {
            await ethereum.enable()
        } catch (e) {
            alert('No permission was granted')
        }
    } else if (window.web3) {
        window.web3 = new Web3(window.web3.currentProvider)
    } else {
        alert('Please install MetaMask')
    }

    new Vue({
      router,
      store,
      render: h => h(App)
    }).$mount('#app')
})
