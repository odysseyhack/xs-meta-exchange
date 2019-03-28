<template>
  <v-container>
    <v-layout
      text-xs-center
      justify-space-around
    >
      <v-card>
        <v-card-text>
          <v-card-title>
            <div class="headline">Transfer Tokens</div>
          </v-card-title>
          <v-card-text>
            <v-flex><v-text-field v-model="send.address" label="Address"></v-text-field></v-flex>
            <v-flex><v-text-field v-model="send.amount" label="Amount"></v-text-field></v-flex>
            <v-flex><v-btn @click="doSend">Send</v-btn></v-flex>
          </v-card-text>
        </v-card-text>
      </v-card>
      <v-card v-if="isController">
        <v-card-text>
          <v-card-title>
            <div class="headline">Print Tokens</div>
          </v-card-title>
          <v-card-text>
            <v-flex><v-text-field v-model="print.address" label="Address"></v-text-field></v-flex>
            <v-flex><v-text-field v-model="print.amount" label="Amount"></v-text-field></v-flex>
            <v-flex><v-btn @click="doPrint">Print</v-btn></v-flex>
          </v-card-text>
        </v-card-text>
      </v-card>
      <v-card>
        <v-card-text>
          <v-card-title>
            <div class="headline">Transactions</div>
          </v-card-title>
          <v-data-table
            :headers="transactionTableHeaders"
            :items="transactions"
            class="elevation-1"
          >
            <template v-slot:items="props">
              <tr>
                  <td>{{ props.item.from }}</td>
                  <td>{{ props.item.to }}</td>
                  <td>{{ props.item.amount }}</td>
              </tr>
            </template>
          </v-data-table>
        </v-card-text>
      </v-card>
    </v-layout>
  </v-container>
</template>

<script>
  export default {
    data: () => ({
      send: {
        address: '',
        amount: 0
      },
      print: {
        address: '',
        amount: 0
      },
      transactionTableHeaders: [{
        text: 'From',
        value: 'from'
      }, {
        text: 'To',
        value: 'to'
      }, {
        text: 'Amount',
        value: 'amount'
      }]
    }),
    methods: {
      doSend () {
        this.$store.dispatch('Wallet/transfer', { to: this.send.address, amount: Number(this.send.amount)})
      },
      doPrint () {
        this.$store.dispatch('Wallet/generateTokens', { to: this.print.address, amount: Number(this.print.amount)})
      }
    },
    computed: {
      isController () {
        return this.$store.state.Wallet.controller
      },
      transactions () {
        return this.$store.state.Wallet.transactions
      }
    }
  }
</script>

<style>

</style>
