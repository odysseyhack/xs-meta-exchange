<template>
    <v-select
        :items="recipes"
        v-model="selected"
        outline
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
            },
            async getRecipes () {
                this.recipes = await this.contract.getRecipes()
            }
        }
    }
</script>

<style scoped>

</style>
