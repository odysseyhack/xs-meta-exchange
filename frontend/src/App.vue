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
        <v-flex xs12 md8 lg6>
          <router-view/>
        </v-flex>
      </v-layout>
    </v-content>
  </v-app>
</template>

<script>
export default {
  name: 'App',
  created () {
    this.$store.dispatch('XS/init')
  },
  computed: {
    resources () {
      return this.$store.state.XS.resources
    }
  },
  watchers: {
    resources (newVal) {
      console.log(newVal)
    }
  }
}
</script>
