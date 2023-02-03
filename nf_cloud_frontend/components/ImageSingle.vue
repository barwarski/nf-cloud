<template>
    <div>
        <h3>  {{ plottype }}: </h3>   
        <ImageViewer :imagepath="filepath" :isPDF="getExtension(filepath)" :isSingle="true" :projectId="projectId" :caption="caption"></ImageViewer>
    </div>
</template>

<script>
import ImageViewer from './ImageViewer.vue';

export default {
    props: ["plottype", "filepath", "projectId", "caption"],
    methods:{
        getExtension(filename) {
            var parts = filename.split('.');
            return parts[parts.length - 1];
        }       
    },
    components: { ImageViewer }
}
</script>