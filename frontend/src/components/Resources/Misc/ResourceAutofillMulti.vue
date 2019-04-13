<template>
    <v-select
            v-model="selection"
            :items="labels"
            attach
            chips
            label="Chips"
            multiple
            outline
    ></v-select>
</template>

<script>
    export default {
        name: "ResourceAutofill",
        data: () => ({
            selection: [''],
        }),
        computed: {
            labels () {
                return this.$store.state.XS.resources.map((i) => i.label)
            },
            selectedAddresses () {
                return this.$store.state.XS.resources
                    .filter((i) => this.selection.includes(i.label))
                    .map((i) => i.address)
            }
        },
    }
</script>

<style scoped>

</style>

