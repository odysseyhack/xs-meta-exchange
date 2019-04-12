<template>
    <v-dialog v-model="isOpen" max-width="600">
        <v-card>
            <v-card-title class="headline">Create resource</v-card-title>

            <v-card-text>
                <v-text-field
                        v-model="label"
                        label="Label"
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
    export default {
        name: "CreateResource",
        data: () => ({
            isOpen: false,
            label: ''
        }),
        methods: {
            open () {
                this.isOpen = true
            },
            close () {
                this.isOpen = false
            },
            submit () {
                this.$store.dispatch('XS/createResource', this.label)
                this.close()
            }
        }
    }
</script>

<style scoped>

</style>
