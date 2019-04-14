<template>
    <v-select
        :items="recipes"
        v-model="selected"
        outline
        placeholder="Recipe"
    ></v-select>
</template>

<script>
    import ResourceDAO from '@/contracts/ResourceDAO'

    export default {
        props: ['resourcedaoAddress'],
        name: "RecipeDropdown",
        data: () => ({
            contract: null,
            selected: '',
            recipes: []
        }),
        mounted () {
            this.init()
        },
        methods: {
            async init () {
                this.contract = await ResourceDAO.at(this.resourcedaoAddress)

                this.getRecipes()
                this.onNewRecipe()
            },
            async getRecipes () {
                this.recipes = await this.contract.getRecipes()
            },
            async onNewRecipe () {
                const blockState = await window.web3.eth.isSyncing()

                this.contract.NewRecipe({ fromBlock: blockState.currentBlock, toBlock: 'latest' }, (err, res) => {
                    this.getRecipes()
                })
            },
        }
    }
</script>

<style scoped>

</style>
