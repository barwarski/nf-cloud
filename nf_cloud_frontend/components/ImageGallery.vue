<template>
    <div >
        <h3>  {{ plottype }}: </h3>   
        <ImageViewer :imagepath="filepath" :isPDF="getExtension(filepath)" :isSingle="false" :projectId="projectId" :caption="caption"></ImageViewer>
    </div>
</template>

<script>
import ImageViewer from './ImageViewer.vue';

export default {
    props: ["plottype", "filepath", "projectId", "caption"],
    methods:{
        getExtension(filename) {
            var parts = filename[0].split('.');
            return parts[parts.length - 1];
        }       
    },
    compute: {
    },
    components: { ImageViewer}
}
</script>