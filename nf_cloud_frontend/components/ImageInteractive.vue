<template>
    <div class="row">
        <div class="col">
            <div class="d-flex flex-column">
                <h3 class="align-self-start">  {{ caption }}:  </h3>
                <div v-for="group in this.groupNames" class="p-2" :key="group">
                        <label > {{ group }}</label>
                        <select :id=group @change="updateColor(group)">
                            <option>#000000</option>
                            <option>#D3D3D3</option>
                            <option>#20B2AA</option>
                            <option>#FF0000</option>
                            <option>#00FF00</option>
                            <option>#0000FF</option>
                            <option>#99FFDD</option>
                            <option>#FF7514</option>
                            <option>#F67C6C</option>
                            <option>#FCE903</option>
                            <option>#F7F9EF</option>
                        </select>
                    </div>
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
    data(){
        return{
            plotData: null,
            groupNumber:null,
            groupNames: null
        }
    },
    mounted(){
        var plotData = (this.$config.nf_cloud_backend_base_url + "/api/projects/"+ String(this.projectId) +"/download-without-login?path="+ String(this.filepath))
        fetch(plotData)
            .then(response => {
            return response.json();
            })
            .then(datas => {
                this.$plotly.newPlot("plot", datas.data, datas.layout)
                this.plotData = datas
                this.groupNumber =  Object.keys(this.plotData.data).length
                this.groupNames = this.getGroupNames(this.plotData)
            });
    },
    methods:{
        getGroupNames(datas){
            var groups = []
            for(var i = 0; i < this.groupNumber; i++){
                groups.push(datas.data[i].legendgroup)
            }
            return groups
        },
        /**
         * 
         * get selected Color (Hex-Code) 
         */
        getColor(groupID){
                var e = document.getElementById(groupID);
                var value = e.value;
                var text = e.options[e.selectedIndex].text;
                return text
        },  
        updateColor(groupID){
            var arrayGroupNames = (Object.values(this.groupNames))
            var index = (arrayGroupNames).indexOf(groupID)
            this.plotData.data[index].marker.color = this.getColor(groupID)
            this.$plotly.newPlot('plot', this.plotData.data, this.plotData.layout);
        }  
    }
}
</script>