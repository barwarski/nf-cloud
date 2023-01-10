# external imports
from flask import jsonify

# internal imports
from nf_cloud_backend import app
from nf_cloud_backend.utility.configuration import Configuration


class WorkflowControllers:
    """
    Handles requests regarding the defined nextflow workflows
    """

    @staticmethod
    @app.route("/api/workflows")
    def workflows():
        """
        Returns
        -------
        JSON with key `nextflow_workflows`, which contains a list of workflow names.
        """
        return jsonify({
            "workflows": sorted([
                workflow
                for workflow in Configuration.values()["workflows"].keys()
            ])
        })

    @staticmethod
    @app.route("/api/workflows/<string:workflow>/arguments")
    def arguments(workflow: str):
        """
        Returns
        -------
        JSON where each key is the name of a workflow argument with value type definition and description.
        """
        return jsonify({
            "arguments": Configuration.values()["workflows"][workflow]["args"]["dynamic"]
        })

    @staticmethod
    @app.route("/api/workflows/<string:workflow>/script")
    def script(workflow: str):
        """
        Returns
        -------
        JSON where each key is the name of a workflow argument with value type definition and description.
        """
        return jsonify({
            "script": Configuration.values()["workflows"][workflow]["script"]
        })
    
    @staticmethod
    @app.route("/api/workflows/<string:workflow>/directory")
    def directory(workflow: str):
        """
        Returns
        -------
        JSON where each key is the name of a workflow argument with value type definition and description.
        """
        return jsonify({
            "directory": Configuration.values()["workflows"][workflow]["directory"]
        })

    @staticmethod
    @app.route("/api/workflows/<string:workflow>/result_definition")
    def result_definition(workflow: str):
        return jsonify(Configuration.values()["workflows"][workflow]["results"])

    @staticmethod
    @app.route("/api/workflows/<string:workflow>/<string:script>/runScript")
    def runScript(workflow: str, script: str):
        """
        Returns
        -------
        Arguments
        """
        mess = "-"
        try:
            #script laufen
            import subprocess
            from pathlib import Path

            directoryPath = str(Path.cwd()) 
            directoryPath = directoryPath.replace("/nf_cloud_backend/controllers/api/workflows_controller.py","/nf_cloud/")
            dataPath = directoryPath + "/uploads/" #+ data
            workflowPath = directoryPath + "/test_workflows/" + workflow + "/"
            outputPath = directoryPath + "/results/" + workflow + "/" 
            scriptPath = workflowPath + "/Scripts/"
            nextflowScript = directoryPath + "/test_workflows/" + workflow + "/" + script #dir + workflow + "/" + script
            workflow_args = "h"

            subprocess.run(f"nextflow {nextflowScript} --output /home/barwariaw/Schreibtisch/", shell=True)
            mess = "successfully run script on " + nextflowScript # + "\n directoryPath: " + directoryPath + " \n datapath: " + dataUrl
        except Exception:
            mess = Exception
        #http://localhost:3001/api/workflows/QC_and_normalization/main.nf/runScript
        return jsonify({
            "run main.nf": mess,
            "directoryPath": directoryPath,
            "dataPath": dataPath,
            "outputPath": outputPath,
            "workflowPath": workflowPath,
            "scriptPath": scriptPath,
            "Nextflow Script": nextflowScript ,
            "Workflow_arguments": workflow_args
        })