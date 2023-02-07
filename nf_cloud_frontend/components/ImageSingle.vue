<template>
    <div>
        <h3>  {{ caption }}: </h3>   
        <ImageViewer :imagepath="filepath" :isSingle="true" :projectId="projectId"></ImageViewer>
        <div><b>{{ caption }}:</b> {{ description }}</div>
    </div>
</template>

<script>
import ImageViewer from './ImageViewer.vue';

export default {
    props: ["caption", "filepath", "projectId", "description"],
    methods:{     
    },
    components: { ImageViewer }
}
</script>