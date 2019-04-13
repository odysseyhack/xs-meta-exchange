<template>
    <v-card>
        <v-card-title class="headline">
            {{ label }}
        </v-card-title>

        <v-card-actions>
            <v-btn @click="$refs.createRecipe.open()">
                Create Recipe
            </v-btn>
        </v-card-actions>

        <create-recipe ref="createRecipe" :contract="contract" />
    </v-card>
</template>

<script>
    import ResourceDAO from '@/contracts/ResourceDAO'
    import CreateRecipe from '@/components/Resources/CreateRecipe'

    export default {
        components: {
            CreateRecipe
        },
        name: "Resource",
        data: () => ({
            label: '',
            contract: null
        }),
        mounted () {
            this.init()
        },
        methods: {
            async init () {
                this.contract = await this.getContract()

                this.label = await this.contract.label()
                //console.log(await this.getRecipes())
            },
            async getContract () {
                return await ResourceDAO.at(this.$route.params.address)
            },
            async getRecipes () {
                const length = await this.contract.nrecipes()
                let res = []

                for (let i=0; i < length; i++) {
                        console.log(this.contract.recipes(i))
                }
            }
        }
    }
</script>

<style scoped>

</style>

