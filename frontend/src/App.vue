<template>
  <v-app>
    <v-toolbar app>
      <v-toolbar-title class="headline text-uppercase">
        <span>XS</span>
        <span class="font-weight-light">EXCHANGE</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn
        flat
        href="https://github.com/vuetifyjs/vuetify/releases/latest"
        target="_blank"
      >
        <span class="mr-2">Balance</span><span>{{balance}}</span>
        <v-icon>fas fa-external-link-alt</v-icon>
      </v-btn>
    </v-toolbar>

    <v-content>
      <router-view/>
    </v-content>
  </v-app>
</template>

<script>
import Token from './contracts/token'

export default {
  name: 'App',
  created () {
    this.initWallet()
  },
  methods: {
    async initWallet () {
      await this.$store.dispatch('Wallet/init')
      //await this.$store.dispatch('Wallet/generateTokens', { amount: 9001 })
      //await this.$store.dispatch('Wallet/getBalance')
      //await this.$store.dispatch('Wallet/checkIfController')
      //await this.$store.dispatch('Wallet/getPastTransfers')
      // await this.$store.dispatch('Wallet/transfer', { to: '0xcE5Fa9c83609d2fc61B48CBF1623CA45d8F777bB', amount: 2})
    }
  },
  data () {
    return {
      //
    }
  },
  computed: {
    balance () {
      return this.$store.state.Wallet.balance
    },
  },
  watch: {

  }
}
</script>
