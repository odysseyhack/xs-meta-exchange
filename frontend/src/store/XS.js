import Vue from 'vue'
import xsInstance from '@/contracts/XS'

export default {
    namespaced: true,
    state: {
        contracts: {
            XS: null
        },
        resources: []
    },
    actions: {
        // Initialization actions start
        async init ({ state, dispatch }) {
            await dispatch('getAccounts')
            await dispatch('getContract')
            dispatch('onNewResource')
            console.log(await state.contracts.XS.listResourcesName())
        },
        async getAccounts ({ commit }) {
            const accounts = await window.web3.eth.getAccounts()
            commit('setAccount', accounts[0])
        },
        async getContract ({ commit }) {
            commit('setXSInstance', await xsInstance.deployed())
        },
        async createResource ({ state, getters }, label) {
            await state.contracts.XS.createResource(label, getters.txParams)
        },
        async request ({ state }, name, recipe, amount) {
            await state.contract.XS.request(name, recipe, amount)
        },
        async composeResource ({ state, commit }, label) {
            let id = await state.contracts.XS.toId(label)
            id = id.words[0]

            const address = await state.contracts.XS.toAddress(id)

            commit('addResource', {
                label,
                id,
                address
                //contract: contract()
            })
        },
        onNewResource ({ state, dispatch }) {
            state.contracts.XS.NewResource({ fromBlock: 0, toBlock: 'latest' }, (err, res) => {
                const label = res.args[0]

                dispatch('composeResource', label)
            })
        }
    },
    mutations: {
        setXSInstance: (state, val) => state.contracts.XS = val,
        setAccount: (state, val) => state.account = val,
        addResource: (state, val) => state.resources.push(val)
    },
    getters: {
        txParams: (state) => ({ from: state.account })
    }
}
