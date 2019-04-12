<template>
    <v-autocomplete
        v-model="selection"
        :items="labels"
        no-data-text="Creates new resource"
        placeholder="Resource"
    ></v-autocomplete>
</template>

<script>
    export default {
        name: "ResourceAutofill",
        data: () => ({
            selection: '',
        }),
        computed: {
            labels () {
                return this.$store.state.XS.resources.map((i) => i.label)
            }
        }
    }
</script>

<style scoped>

</style>
