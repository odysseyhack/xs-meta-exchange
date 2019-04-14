<template>
    <v-dialog v-model="isOpen" max-width="600">
        <v-card>
            <v-card-title class="headline">Request resource</v-card-title>
            <v-card-text>
                <v-text-field
                    v-model="amount"
                    label="amount"
                    outline
                ></v-text-field>

            </v-card-text>

            <v-card-actions>
                <v-spacer />

                <v-btn round outline color="red" @click="close">
                    Cancel
                </v-btn>

                <v-btn round outline color="green" @click="submit">
                    Submit
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
    import ResourceAutofill from './Misc/ResourceAutofill'

    export default {
        props: ['contract'],
        name: "CreateResource",
        data: () => ({
            isOpen: false,
            resource: '',
            amount: 0,
            recipeId: 0,
            recipeName: ''
        }),
        methods: {
            open (label, recipeId, recipeName) {
                this.isOpen = true
                this.label = label
                this.recipeId = recipeId
                this.recipeName = recipeName
            },
            close () {
                this.isOpen = false
            },
            async submit () {
                const accounts = await window.web3.eth.getAccounts()
                console.log(this.label, this.recipeId, 'LOCATION', this.amount)
                console.log(this.contract.address)
                this.contract.requestRecipe(1, this.amount, 'location', { from: accounts[0] })
                this.close()
            }
        },
        components: {
            ResourceAutofill
        },
    }
</script>

<style scoped>

</style>
