<template>
    <div>
      <div v-if="isPDF != 'pdf'" class="images" v-viewer="{movable: false}">
        <img  v-for="src in imagepath" :src="src" :key="src" height="250" width="33%">
      </div>
      <div v-if="isPDF == 'pdf'" class="images" v-viewer="{movable: false}">
        <img v-if="isSingle" :src="convertToBase64andBack(imagepath, projectId)" height="250" width="33%">
      </div>
      <p> Filetype {{ isPDF }}</p>
    </div>
  </template>
  <script>
    import 'viewerjs/dist/viewer.css'
    import { directive as viewer } from "v-viewer"
    import VuePdfEmbed from 'vue-pdf-embed/dist/vue2-pdf-embed'
    import Vue from 'vue';
    import * as fs from 'fs'

    export default {
      data(){
        return{
            computedPaths: "x"
        }
      },
      props: ['imagepath', 'isPDF', 'isSingle', 'projectId', 'backendServerUrl'],
      directives: {
        viewer: viewer({
          debug: true,
        }),
      },
      methods: {
        show () {
          const viewer = this.$el.querySelector('.images').$viewer
          viewer.show()
          const fs = require('fs');
          var files = []  
          const testFolder = 'home/barwariaw/Schreibtisch/';
          fs.readdirSync(testFolder).forEach(file => {
              files.push(file);
            });
          this.ploturl = files  
        },
        convertToBase64andBack(src, projectId){ 
          console.log("trying ", src)
          var parts = src.split('=');
          src = parts[parts.length - 1]; 
          fetch(`http://localhost:3001/api/projects/${projectId}/${src}/convert-to-base64-png`, {
            }).then(response => {
                if(response.ok) {
                    response.json().then(data => {
                        console.log("Hat geklappt ", data)
                    })
                } else {
                    console.log(response, "hat nicht gekklaüpt")
                }
            })
            fetch()
            return "http://localhost:3001/api/projects/" + projectId + "/download-without-login?path=" + src
        }
      },
      components:{ VuePdfEmbed }
    }
  </script>