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

                <resource-autofill ref="resource" />
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
        props: [],
        name: "CreateResource",
        data: () => ({
            isOpen: false,
            resource: '',
            amount: 0
        }),
        methods: {
            open () {
                this.isOpen = true
            },
            close () {
                this.isOpen = false
            },
            submit () {
                const resource = this.$refs.Resource.resource

                this.$store.dispatch('Wallet/generateTokens', {
                    to: this.print,
                    amount: Number(this.amount)
                })
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
