// import SimpleStorage from './contracts/SimpleStorage.json'
// import ComplexStorage from './contracts/ComplexStorage.json'
// import TutorialToken from './contracts/TutorialToken.json'
import PokemonFight from './contracts/PokemonFight.json';
const options = {
  web3: {
    block: false,
    fallback: {
      type: 'ws',
      url: 'ws://127.0.0.1:7545'
    }
  },
  contracts: [PokemonFight],
  events: {
    SimpleStorage: ['BattleStatus']
  },
  polls: {
    accounts: 15000
  }
}

export default options
