<template>
    <v-card>
        <v-card-title class="headline">
            Resources
        </v-card-title>
        <v-card-text>
            <v-list>
                <v-list-tile
                    v-for="resource in resources"
                    ripple
                    :to="`/resource/${resource.address}`"
                >
                    {{ resource.label }}
                </v-list-tile>
            </v-list>
            <v-card-actions>
                <v-btn round outline @click="$refs.createResource.open()">Create</v-btn>
                <v-btn round outline @click="$refs.requestResource.open()">Request</v-btn>
            </v-card-actions>
        </v-card-text>
        <create-resource ref="createResource" />
        <request-resource ref="requestResource" />
    </v-card>
</template>

<script>
    import CreateResource from '@/components/Resources/CreateResource'
    import RequestResource from '@/components/Resources/RequestResource'

    export default {
        name: "XSview",
        computed: {
            resources () {
                return this.$store.state.XS.resources
            },
        },
        components: {
            CreateResource,
            RequestResource
        }
    }
</script>

<style scoped>

</style>
