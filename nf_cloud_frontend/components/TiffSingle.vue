<template>
    <div class="row">
        <div class="col">
            <div class="d-flex flex-column">
                <h3 class="align-self-start">  {{ caption }}:  </h3>
                <img src="($config.nf_cloud_backend_base_url + '/api/projects/'+projectId+'/download-without-login?path='+filepath+'&is-inline=1')" height="400" width="50%">
                <iframe width=50% height=200 src="$config.nf_cloud_backend_base_url + '/api/projects/'+projectId+'/download-without-login?path='+filepath+'&is-inline=1'" type="image/tiff"> </iframe>
                <iframe width=50% height=200 src="localhost:3001/api/projects/6/download-without-login?path=at3_1m4_01.tif&is-inline=1" type="image/tiff"> </iframe>

                <div class="align-self-center scaled" v-html="svg"></div>
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
    data(){
        return {
            svg: null
            }
    },
    mounted(){
        this.loadSVG(this.$config.nf_cloud_backend_base_url+"/api/projects/"+ String(this.projectId) +"/download-without-login?path="+ String(this.filepath)+"&is-inline=1")

        //document.getElementById('pdf').data = this.$config.nf_cloud_backend_base_url + "/api/projects/"+ String(this.projectId) +"/download-without-login?path="+ String(this.filepath)+"&is-inline=1"
    },
    methods:{
        loadSVG(url){
            return fetch(url).then(response => {
                if(response.ok) {
                    response.text().then(response_data => {
                        var oParser = new DOMParser();
                        var oDOM = oParser.parseFromString(response_data, "image");
                        this.svg = response_data
                        console.log("type of response_data: "+typeof(response_data) + " inhaölt:"+response_data) //PDF?
                        console.log("Convertetd: " + typeof(oDOM)+ "inhalt " + oDOM)
                    })
                } else if(response.status == 404) {
                    this.project_not_found = true
                } else {
                    this.handleUnknownResponse(response)
                }
            })
        }
    }  
}
</script>