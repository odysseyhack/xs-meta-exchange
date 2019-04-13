import contract from 'truffle-contract'
import resourceDaoArtifacts from '../../../build/contracts/ResourceDAO.json'

const instance = contract(resourceDaoArtifacts)

instance.setProvider(window.ethereum)

export default instance
