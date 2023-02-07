<template>
    <div class="row">
        <div class="col">
            <div class="d-flex flex-column">
                <h3 class="align-self-start">  {{ caption }}:  </h3>
                <div class="align-self-center scaled" id="plot"></div>    
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
    mounted(){
        var plotData = (this.$config.nf_cloud_backend_base_url + "/api/projects/"+ String(this.projectId) +"/download-without-login?path="+ String(this.filepath))
        fetch(plotData)
            .then(response => {
            return response.json();
            })
            .then(datas => {
                this.$plotly.newPlot("plot", datas.data, datas.layout)
            });
    }
}
</script>