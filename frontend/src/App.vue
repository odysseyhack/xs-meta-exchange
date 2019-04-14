<template>
  <v-app>
    <v-toolbar app>
      <v-toolbar-title class="headline text-uppercase">
        <span>XS</span>
        <span class="font-weight-light">EXCHANGE</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
    </v-toolbar>

    <v-content>
      <v-layout justify-center align-center>
        <v-flex xs12 md8 lg6 style="margin-top: 70px">
          <router-view />
        </v-flex>
      </v-layout>
    </v-content>
  </v-app>
</template>

<script>
import Web3 from 'web3'

export default {
  name: 'App',
  data: () => {

  },
  mounted () {
    this.init()
  },
  methods: {
    async init () {
      await this.initWeb3()
      await this.$store.dispatch('XS/init')
    },
    async initWeb3 () {
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
    }
  },
}
</script>
