<template>
    <v-select
        v-model="selected"
        :items="resourceLabels"
        outline
    ></v-select>
</template>

<script>
    export default {
        name: "ResourceDropdown",
        data: () => ({
            selected: ''
        }),
        computed: {
            resources () {
                return this.$store.state.XS.resources
            },
            resourceLabels () {
                return this.resources.map((i) => i.label)
            }
        },
        watch: {
            selected () {
                const selectedResource = this.resources.find((i) => i.label === this.selected)
                console.log('resourcedropdown')
                console.log(selectedResource, this.resources)
                this.$emit('change', selectedResource)
            }
        }
    }
</script>

<style scoped>

</style>
