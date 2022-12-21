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
    @app.route("/api/workflows/<string:workflow>/<string:script>/runScript")
    def runScript(workflow: str, script: str):
        """
        Returns
        -------
        JSON where each key is the name of a workflow argument with value type definition and description.
        """
        mess = "-"
        try:
            #script laufen
            import subprocess
            dir = "~/Code/nf-cloud/test_workflows"
            mainScript = dir + "/" + workflow + "/" + script
            subprocess.run(f"nextflow {mainScript} ", shell=True)
            mess = "successfully "
        except Exception:
            mess = Exception
        #else:
        #    mess = "something else gone wrong " + str(scriptPath)
        return jsonify({
            "run main.nf": mess
        })