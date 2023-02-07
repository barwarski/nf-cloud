<style>
.scaled {
    background-color: aquamarine;
  }
</style>

<template>
    <div class="row">
        <div class="col">
            <div class="d-flex flex-column">
                <h3 class="align-self-start">  {{ caption }}:  </h3>    
                <div class="align-self-center scaled" v-html="svg"></div>
                <div class="align-self-center">
                    <b>{{ caption }}:</b> {{ description }}
                </div>
            </div>
        </div>
    </div>
</template>

<script>

export default {
    props: ["caption", "filepath", "projectId", "description"],
    data(){
        return {
            svg: null
            }
    },
    mounted(){
        this.loadSVG(this.$config.nf_cloud_backend_base_url+"/api/projects/"+ String(this.projectId) +"/download-without-login?path="+ String(this.filepath)+"&is-inline=1")
    },
    methods:{
        loadSVG(url){
            return fetch(url).then(response => {
                if(response.ok) {
                    response.text().then(response_data => {
                        var oParser = new DOMParser();
                        var oDOM = oParser.parseFromString(response_data, "image/svg+xml");
                        //this.svg = '<svg version="1.1" baseProfile="full" width="300" height="200" viewBox="0 0 200 300" xmlns="http://www.w3.org/2000/svg"> <rect width="100%" height="100%" fill="red" /> <circle cx="150" cy="100" r="80" fill="green" /><text x="150" y="125" font-size="60" text-anchor="middle" fill="white">SVG</text></svg>'
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