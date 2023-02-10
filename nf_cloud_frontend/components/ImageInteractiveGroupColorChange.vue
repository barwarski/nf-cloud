<template>
    <div class="row">
        <div class="col">
            <div class="d-flex flex-column">
                <h3 class="align-self-start">  {{ caption }}:  </h3>
                <form class="d-flex align-items-end flex-column">
                    <div class="p-2">
                        <label for="fname">Color group1:</label>
                        <select id="group1" @change="updateColor('group1')">
                            <option>black</option>
                            <option>lightsteelblue</option>
                            <option>lightseagreen</option>
                            <option>green</option>
                            <option>red</option>
                            <option>blue</option>
                            <option>aquamarine</option>
                            <option>orange</option>
                            <option>coral</option>
                            <option>yellow</option>
                        </select>
                    </div>
                    <div class="p-2">
                        <label for=“lname”>Color group2:</label>
                        <select id="group2" @change="updateColor('group2')">
                            <option>black</option>
                            <option>lightsteelblue</option>
                            <option>lightseagreen</option>
                            <option>green</option>
                            <option>red</option>
                            <option>blue</option>
                            <option>aquamarine</option>
                            <option>orange</option>
                            <option>coral</option>
                            <option>yellow</option>
                        </select>
                    </div>
                </form>
                <div class="align-self-center scaled" id="chart"></div>    
                <div class="align-self-center">
                    <b>{{ caption }}:</b> {{ description }}
                    <br>
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
            sign : {
                x : [1,2,3,4,5,1,2,3,4,5],
                y : [1,2,3,1,2,3,1,2,3,1],
                mode: 'markers',
                marker: {
                    color: 'rgb(128, 0, 128)',
                    size: 8
                }
            },
            no : {
                x : [1,2,1,2,1,2,1,2,1,2],
                y : [1,2,3,1,2,3,1,2,3,1],
                mode: 'markers',
                marker: {
                    color: "yellow",
                    size: 8
                }
            },
            layout : {
                title: {
                    //text: sign.marker.color,
                    font: {
                    family: 'Courier New, monospace',
                    size: 24
                    },
                    xref: 'paper',
                    x: 0.05,
                }
            }
        }       
    },
    mounted(){       
        var datas = [this.sign, this.no];
        this.$plotly.newPlot('chart', datas, this.layout);
    },
    methods:{  
        /**
         * Run function if Select-Element get triggered. -> Return choosen Option (Color)
         */    
        getColor(groupID){
                var e = document.getElementById(groupID);
                var value = e.value;
                var text = e.options[e.selectedIndex].text;
                return text
        },  
        updateColor(groupID){
            this.sign.marker.color = (groupID == "group1") ? this.getColor(groupID) :  this.sign.marker.color;
            this.no.marker.color = (groupID == "group2") ? this.getColor(groupID) :  this.no.marker.color;
            var datas = [this.sign, this.no];

            this.$plotly.newPlot('chart', datas, this.layout);
        }  
    }
}
</script>