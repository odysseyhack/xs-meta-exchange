import contract from 'truffle-contract'
import xsArtifacts from '../../../build/contracts/XS.json'

const instance = contract(xsArtifacts)

instance.setProvider(window.ethereum)

export default instance
