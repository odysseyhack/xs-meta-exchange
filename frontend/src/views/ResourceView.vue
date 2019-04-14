<template>
    <v-card>
        <v-card-title class="headline">
            {{ label }}
        </v-card-title>

        <v-card-text>
            <v-list two-line>
                <v-list-tile v-for="(recipe, id) in recipes">
                    <v-list-tile-content>
                        {{ recipe.name }}
                    </v-list-tile-content>
                    <v-list-tile-action>
                        {{ recipe.truePrice }}
                        <v-btn outline round @click="$refs.requestResource.open(label, id, recipe.name)">Request</v-btn>
                    </v-list-tile-action>
                </v-list-tile>
            </v-list>
        </v-card-text>

        <v-card-actions>
            <v-btn @click="$refs.createRecipe.open()">
                Create Recipe
            </v-btn>
        </v-card-actions>

        <create-recipe ref="createRecipe" :contract="contract" @done="reload"/>
        <request-resource ref="requestResource" :contract="contract" />
    </v-card>
</template>

<script>
    import ResourceDAO from '@/contracts/ResourceDAO'
    import CreateRecipe from '@/components/Resources/CreateRecipe'
    import RequestResource from '@/components/Resources/RequestResource'

    import Vue from 'vue'

    export default {
        components: {
            CreateRecipe,
            RequestResource
        },
        name: "Resource",
        data: () => ({
            label: '',
            contract: null,
            recipes: []
        }),
        mounted () {
            this.init()
        },
        methods: {
            async init () {
                this.contract = await this.getContract()

                this.label = await this.contract.label()
                await this.getRecipes()
            },
            async getContract () {
                return await ResourceDAO.at(this.$route.params.address)
            },
            async getRecipes () {
                const length = await this.contract.nrecipes()
                let res = []

                for (let i=0; i < length; i++) {
                    console.log('getrecipe')
                    const recipe = await this.contract.recipes(i)
                    console.log('getTruePrice')
                    let truePrice = []
                    try {
                        truePrice = await this.contract.getTruePrice(i)
                    } catch (e) {
                        console.error(e)
                        truePrice = ''
                    }
                    console.log(truePrice)
                    Vue.set(this.recipes, i, {
                        name: recipe.name,
                        truePrice: truePrice !== '' ? truePrice.map((i) => i.words[0]) : truePrice
                    })
                }
            },
            async onNewRecipe () {
                const blockState = await window.web3.eth.isSyncing()

                this.contract.NewRecipe({ fromBlock: 0, toBlock: 'latest' }, (err, res) => {
                    this.getRecipes()
                })
            },
            reload () {
                this.$parent.routeKey = String(math.random())
            }
        }
    }
</script>

<style scoped>

</style>

