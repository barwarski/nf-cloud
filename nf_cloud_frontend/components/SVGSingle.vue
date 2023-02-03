<style>
.scaled {
    width: 50%;
    height: 400px;
  }
</style>

<template>
    <div class="ontainer">
        <h3>  {{ plottype }}:  </h3>   
        <div class="scaled" v-html="svg"></div>
        <p>{{ caption }}</p>
    </div>
</template>

<script>

export default {
    props: ["plottype", "filepath", "projectId", "caption"],
    data(){
        return {
            svg: null
            }
    },
    mounted(){
        this.loadSVG("http://localhost:3001/api/projects/"+ String(this.projectId) +"/download-without-login?path="+ String(this.filepath)+"&is-inline=1")
    },
    methods:{
        loadSVG(url){
            return fetch(url).then(response => {
                if(response.ok) {
                    response.text().then(response_data => {
                        this.svg = response_data
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