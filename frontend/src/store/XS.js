import contract from 'truffle-contract'
import barterArtifacts from '../../../build/contracts/Barter.json'
import xsArtifacts from '../../../build/contracts/XS.json'

const processTransfer = (transfer) => {
    return {
        from: transfer.returnValues._from,
        to: transfer.returnValues._to,
        amount: Number(transfer.returnValues._amount)
    }
}

export default {
    namespaced: true,
    state: {
        init: false,
        controller: false,
        instance: null,
        account: '',
        balance: 0,
        transactions: []
    },
    actions: {
        // Initialization actions start
        async init ({ dispatch }) {
            await dispatch('getAccounts')
            await dispatch('getContract')
            await dispatch('getBalance')
            await dispatch('checkIfController')
            await dispatch('getPastTransfers')
            await dispatch('onTransfer')
        },
        async getAccounts ({ commit }) {
            const accounts = await window.web3.eth.getAccounts()
            commit('setAccount', accounts[0])
        },
        async getContract ({ commit }) {
            const instance = await contract(barterArtifacts)
            instance.setProvider(window.ethereum)
            commit('setInstance', await instance.deployed())
        },
        async getPastTransfers ({ commit, state }) {
            const transfers = await state.instance.getPastEvents('Transfer', { fromBlock: 0, toBlock: 'latest'})
            commit('setPastTransfers', transfers)
        },
        async checkIfController ({ commit, state }) {
            commit('setIfController', await state.instance.amIController())
        },
        // initialization actions end
        // actions start
        async generateTokens ({ dispatch, state, getters }, { amount, to = false }) {
            state.instance.generateTokens(!to ? state.account : to, amount, getters.txParams)
        },

        async createTokens ({ dispatch, state, getters }, { amount, label }) {
            state.instance.registerEntity(label, amount, getters.txParams)
        },
        async getBalance ({ state, commit }) {
            const res = await state.instance.balanceOf(state.account)
            commit('setBalance', res.words[0])
        },
        async transfer ({ state, dispatch, getters }, { to, amount }) {
            console.log(to, amount)
            await state.instance.transfer(to, amount, getters.txParams)
        },
        async onTransfer ({ state, commit, dispatch }) {
            state.instance.Transfer({ fromBlock: 0, toBlock: 'latest' }, (err, res) => {
                commit('addTransfer', processTransfer(res))
                dispatch('getBalance')
            })
        }
    },
    mutations: {
        addTransfer: (state, val) => state.transactions.push(val),
        setPastTransfers: (state, val) => state.transactions = val.map(processTransfer),
        setIfController: (state, val) => state.controller = val,
        setAccount: (state, val) => state.account = val,
        setInstance: (state, val) => state.instance = val,
        setBalance: (state, val) => state.balance = val,
    },
    getters: {
        txParams: (state) => ({ from: state.account })
    }
}
