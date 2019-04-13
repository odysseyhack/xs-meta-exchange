<template>
    <v-dialog v-model="isOpen" max-width="600">
        <v-card>
            <v-card-title class="headline">Create recipe</v-card-title>

            <v-card-text>
                <v-text-field
                    v-model="label"
                    label="Label"
                    outline
                ></v-text-field>

                <v-spacer />
                Recipe components
                <v-layout column v-for="(component, index) in components">
                    <v-divider style="margin-bottom: 27px;" />
                    <v-layout row>
                        <v-flex xs8>
                            <resource-dropdown @change="resourceSelected(index, $event)" />
                        </v-flex>
                        <v-flex xs4>
                            <v-text-field
                                    label="Quantity"
                                    :value="component.quantity"
                                    @change="component.quantity = Number($event)"
                                    outline
                            ></v-text-field>
                        </v-flex>
                    </v-layout>
                    <recipe-dropdown v-if="component.resource !== null" :resourcedao-address="component.resource.address" />
                </v-layout>
                <v-flex row>
                    <v-btn round outline @click="addComponent">Add component</v-btn>
                    <v-btn round outline @click="removeComponent">Remove component</v-btn>
                </v-flex>
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
    import ResourceDropdown from './Misc/ResourceDropdown'
    import RecipeDropdown from './Misc/RecipeDropdown'

    export default {
        name: "CreateRecipe",
        components: {
            ResourceDropdown,
            RecipeDropdown
        },
        data: () => ({
            isOpen: false,
            label: '',
            components: [
                {
                    resource: null,
                    quantity: 0
                }
            ]
        }),
        methods: {
            resourceSelected (index, resource) {
                console.log(resource)
                this.components[index].resource = resource
            },
            addComponent () {
                this.components.push({
                    resource: null,
                    quantity: 0
                })
            },
            removeComponent () {
                this.components.pop()
            },
            open () {
                this.isOpen = true
            },
            close () {
                this.isOpen = false
            },
            submit () {
                this.$parent.contract.addRecipe(label, this.$refs.components.selectedAddresses, [0], this.$refs.components.map(() => 0))
                // componentRecipe ??
                //this.$parent.contract.addRecipe(this.)

                //this.close()
            }
        }
    }
</script>

<style scoped>

</style>
