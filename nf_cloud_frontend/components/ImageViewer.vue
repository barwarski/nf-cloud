<template>
    <div>
      <div class="images" v-viewer="{movable: false}">
          <img v-for="src in imagepath" :src="($config.nf_cloud_backend_base_url + '/api/projects/'+projectId+'/download-without-login?path='+src+'&is-inline=1')" :key="src" height="400" width="50%">
      </div>
    </div>
  </template>
  <script>
    import 'viewerjs/dist/viewer.css'
    import { directive as viewer } from "v-viewer"

    export default {
      data(){
        return{
            computedPaths: "x"
        }
      },
      props: ['imagepath', 'isSingle', 'projectId'],
      directives: {
        viewer: viewer({
          debug: true,
        }),
      }
      ,
      methods: {
      },
      computed:{
      },
      components:{  }
    }
  </script>