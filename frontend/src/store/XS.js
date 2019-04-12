import contract from 'truffle-contract'
// import barterArtifacts from '../../../build/contracts/Barter.json'
import xsArtifacts from '../../../build/contracts/XS.json'

export default {
    namespaced: true,
    state: {
        contracts: {
            XS: null
        }
    },
    actions: {
        // Initialization actions start
        async init ({ dispatch }) {
            await dispatch('getAccounts')
            await dispatch('getContract')
        },
        async getAccounts ({ commit }) {
            const accounts = await window.web3.eth.getAccounts()
            commit('setAccount', accounts[0])
        },
        async getContract ({ commit }) {
            const instance = await contract(xsArtifacts)
            instance.setProvider(window.ethereum)
            commit('setXSInstance', await instance.deployed())
        },
    },
    mutations: {
        setXSInstance: (state, val) => state.contracts.XS = val,
        setAccount: (state, val) => state.account = val,
    },
    getters: {
        txParams: (state) => ({ from: state.account })
    }
}
