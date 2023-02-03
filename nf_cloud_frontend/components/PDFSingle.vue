<template>
    <div>
        <h3>  {{ plottype }}:  </h3>   
        <object id="pdf" type="application/pdf" data="" height="400" width="50%"></object>
        <p>{{ caption }}</p>
    </div>
</template>

<script>
import ImageViewer from './ImageViewer.vue';

export default {
    props: ["plottype", "filepath", "projectId", "caption"],
    mounted(){
        document.getElementById('pdf').data = "http://localhost:3001/api/projects/"+ String(this.projectId) +"/download-without-login?path="+ String(this.filepath)+"&is-inline=1"
    }  
}
</script>