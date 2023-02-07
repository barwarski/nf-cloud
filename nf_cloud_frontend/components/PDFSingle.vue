<template>
    <div class="row">
        <div class="col">
            <div class="d-flex flex-column">
                <h3 class="align-self-start">  {{ caption }}:  </h3>
                <object class="align-self-center scaled" id="pdf" type="application/pdf" data="" height="600" width="75%"></object>    
                <div class="align-self-center">
                    <b>{{ caption }}:</b> {{ description }}
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import ImageViewer from './ImageViewer.vue';

export default {
    props: ["caption", "filepath", "projectId", "description"],
    mounted(){
        document.getElementById('pdf').data = this.$config.nf_cloud_backend_base_url + "/api/projects/"+ String(this.projectId) +"/download-without-login?path="+ String(this.filepath)+"&is-inline=1"
    }  
}
</script>