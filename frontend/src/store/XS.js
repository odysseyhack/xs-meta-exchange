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
            //await dispatch('createResource', 'hello')
            await dispatch('getResources')
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
        async createResource ({ state, getters }, label) {
            await state.contracts.XS.createResource(label, getters.txParams)
        },
        async request ({ state }, name, recipe, amount) {
            await state.contract.XS.request(name, recipe, amount)
        },
        async getResources ({ state }) {
            console.log(await state.contracts.XS.listResources())
            console.log(await state.contracts.XS.listResourcesName())
        }
    },
    mutations: {
        setXSInstance: (state, val) => state.contracts.XS = val,
        setAccount: (state, val) => state.account = val,
    },
    getters: {
        txParams: (state) => ({ from: state.account })
    }
}
