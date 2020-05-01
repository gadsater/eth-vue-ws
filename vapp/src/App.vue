<template>
  <div v-if="isDrizzleInitialized" id="app">
    <section>
      <div class="columns">
        <div class="column"></div>
        <div class="column">
          <div class="container">
            <div class="card">
              <div class="card-content">
                <b-field label="Player 1 - Choose your Pokemon">
                  <b-select
                    v-model="pokeLeft"
                    placeholder="Choose pokemon..."
                    expanded
                  >
                    <option
                      v-for="pokemon in pokemonList"
                      :value="pokemon"
                      v-bind:key="pokemon"
                      >{{ pokemon }}</option
                    >
                  </b-select>
                </b-field>
                <b-field label="Player 2 - Choose your Pokemon">
                  <b-select
                    v-model="pokeRight"
                    placeholder="Choose pokemon..."
                    expanded
                  >
                    <option
                      v-for="pokemon in pokemonList"
                      :value="pokemon"
                      v-bind:key="pokemon"
                      >{{ pokemon }}</option
                    >
                  </b-select>
                </b-field>
                <div
                  class="columns is-centered"
                  v-if="pokeLeft.length > 0 && pokeRight.length > 0"
                >
                  <div class="column is-half">
                    <div class="box has-text-centered is-shadowless">
                      <b-button type="is-primary" @click="startBattle" expanded
                        >Battle</b-button
                      >
                    </div>
                  </div>
                  <div class="column is-half">
                    <div class="box has-text-centered is-shadowless">
                      <b-button type="is-primary" @click="reset" expanded
                        >Reset</b-button
                      >
                    </div>
                  </div>
                </div>
              </div>
              <b-table :data="tableData" :columns="tableColumns"></b-table>
            </div>
          </div>
        </div>
        <div class="column"></div>
      </div>
    </section>
  </div>

  <div v-else>Loading...</div>
</template>

<script>
// import TutorialToken from "./TutorialToken";
// import SimpleStorage from "./SimpleStorage";
// import ComplexStorage from "./ComplexStorage";
// import PokemonFight from "./PokemonFight";
import { mapGetters } from "vuex";
import Vue from "vue";
import PokeData from "../pokemon_data/pokemon.json";

export default {
  name: "app",
  components: {
    // PokemonFight
  },
  data() {
    return {
      pokeLeft: "",
      pokeRight: "",
      pokemonList: [],
      pokeBattle: {},
      tableData: []
    };
  },
  computed: {
    ...mapGetters("drizzle", ["isDrizzleInitialized", "drizzleInstance"]),
    ...mapGetters("accounts", ["activeAccount", "activeBalance"]),
    pokeLeftStats() {
      return PokeData[this.pokeLeft];
    },
    pokeRightStats() {
      return PokeData[this.pokeRight];
    },
    tableColumns() {
      return [
        {
          field: "pokemon1",
          label: "POKEMON 1",
          subheading: this.pokeLeft,
          centered: true
        },
        {
          field: "pokemon2",
          label: "POKEMON 2",
          subheading: this.pokeRight,
          centered: true
        }
      ];
    }
  },
  created() {
    let pokeArray = [];
    Object.keys(PokeData).forEach(key => {
      pokeArray.push(key);
    });
    this.pokemonList = pokeArray;
  },
  methods: {
    startBattle() {
      while (this.tableData.length) {
        this.tableData.pop();
      }
      let pokeLeftData = JSON.parse(JSON.stringify(this.pokeLeftStats));
      let pokeRightData = JSON.parse(JSON.stringify(this.pokeRightStats));
      let round = 0;
      Vue.set(this.pokeBattle, round, {
        Pokemon1: {
          PokemonName: pokeLeftData["name"],
          PokemonHealth: pokeLeftData["hp"]
        },
        Pokemon2: {
          PokemonName: pokeRightData["name"],
          PokemonHealth: pokeRightData["hp"]
        }
      });
      this.tableData.push({
        round: round,
        pokemon1: pokeLeftData["hp"],
        pokemon2: pokeRightData["hp"]
      });
      this.drizzleInstance.contracts.PokemonFight.methods.battleStart.cacheSend(
        pokeLeftData["name"],
        pokeLeftData["hp"],
        pokeRightData["name"],
        pokeRightData["hp"],
        { from: this.activeAccount, gas: 2000000 }
      );
      while (pokeLeftData["hp"] != 0 && pokeRightData["hp"] != 0) {
        let pokeRightDefense = pokeRightData["defense"] * Math.random();
        let pokeLeftDefense = pokeLeftData["defense"] * Math.random();

        let pokeRightAttack = pokeRightData["attack"] * (1 / pokeLeftDefense);
        let pokeLeftAttack = pokeLeftData["attack"] * (1 / pokeRightDefense);

        pokeRightData["hp"] = Math.floor(
          Math.max(pokeRightData["hp"] - pokeLeftAttack, 0)
        );
        pokeLeftData["hp"] = Math.floor(
          Math.max(pokeLeftData["hp"] - pokeRightAttack, 0)
        );
        round++;
        Vue.set(this.pokeBattle, round, {
          Pokemon1: {
            PokemonName: pokeLeftData["name"],
            PokemonHealth: pokeLeftData["hp"]
          },
          Pokemon2: {
            PokemonName: pokeRightData["name"],
            PokemonHealth: pokeRightData["hp"]
          }
        });
        this.tableData.push({
          round: round,
          pokemon1: pokeLeftData["hp"],
          pokemon2: pokeRightData["hp"]
        });
        this.drizzleInstance.contracts.PokemonFight.methods.battleContinue.cacheSend(
          pokeLeftData["name"],
          pokeLeftData["hp"],
          pokeRightData["name"],
          pokeRightData["hp"],
          { from: this.activeAccount, gas: 2000000 }
        );
        // console.log(round, pokeRightData["hp"], pokeLeftData["hp"]);
      }
    },
    reset() {
      this.pokeLeft = "";
      this.pokeRight = "";
      this.tableData = [];
      this.pokeBattle = {};
    }
  }
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #000000;
  margin-top: 60px;
}
</style>
