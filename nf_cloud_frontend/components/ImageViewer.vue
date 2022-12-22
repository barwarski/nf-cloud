<template>
  <div>
    <div class="images" v-viewer="{movable: false}">
      <img v-for="src in images" :src="src" :key="src">
    </div>
    <button type="button" @click="show">Show</button>
    <div> siehe :{{ ploturl }}</div>
  </div>
</template>
<script>
  import 'viewerjs/dist/viewer.css'
  import { directive as viewer } from "v-viewer"
  import Vue from 'vue';
  
  export default {
    directives: {
      viewer: viewer({
        debug: true,
      }),
    },
    data() {
      return {
        images: [
        "@/assets/src/PCA_plot_nonorm_labelled.pdf",

        "home/barwariaw/Code/nf-cloud/results/QC_and_normalization/MA_Plots_nonorm.pdf",
        "https://picsum.photos/200/200"
        ],
        ploturl: "d"
      };
    },
    methods: {
      show () {
        const viewer = this.$el.querySelector('.images').$viewer
        viewer.show()
        const fs = require('fs');
        var files = []  
        const testFolder = 'home/barwariaw/Code/nf-cloud/results/QC_and_normalization/';

        fs.readdirSync(testFolder).forEach(file => {
            files.push(file);
          });
        this.ploturl = files  
      }
    },
    compute:{
      plotImages: function(){
      const testFolder = 'home/barwariaw/Code/nf-cloud/results/QC_and_normalization/';
      return testFolder
      /*$.getJSON('./results/QC_and/normalization', data => {
        return(data); //["doc1.jpg", "doc2.jpg", "doc3.jpg"] 
      });
      const fs = require('fs');
      var files = []  
      fs.readdirSync(testFolder).forEach(file => {
          files.push(file);
        });
      return files*/  
      }
    }
  }
</script>