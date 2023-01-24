<template>
    <div>
        <h3> {{ plottype }} </h3>
        <div id="plot"></div>
        <p>  Bildunterschrift </p>
    </div>
    
</template>

<script>
export default {
    props: ["plottype", "filepath", "projectId"],
    mounted(){
        var plotData = ("http://localhost:3001/api/projects/"+ String(this.projectId) +"/download-without-login?path="+ String(this.filepath))
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