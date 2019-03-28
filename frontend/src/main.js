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
    console.log(window.ethereum)
    console.log(window.web3)
    if (window.ethereum) {
        console.log('set Ethereum')
        console.log(ethereum)
        window.web3 = new Web3(window.ethereum)
        try {
            await ethereum.enable()
        } catch (e) {

        }
    } else if (window.web3) {
        console.log('set Web3')
        window.web3 = new Web3(window.web3.currentProvider)
    } else {
        alert('No MetaMask found')
    }

    new Vue({
      router,
      store,
      render: h => h(App)
    }).$mount('#app')
})
