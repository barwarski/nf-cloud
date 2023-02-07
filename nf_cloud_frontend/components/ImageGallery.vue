<template>
    <div >
        <h3>  {{ caption }}: </h3>   
        <ImageViewer :imagepath="filepath" :isSingle="false" :projectId="projectId"></ImageViewer>
        <p style="text-align:center"><b>{{ caption }}:</b> {{ description }}</p>
    </div>
</template>

<script>
import ImageViewer from './ImageViewer.vue';

export default {
    props: ["caption", "filepath", "projectId", "description"],
    methods:{    
    },
    compute: {
    },
    components: { ImageViewer}
}
</script>