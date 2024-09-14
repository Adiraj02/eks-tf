from flask import Flask, jsonify
from kubernetes import client, config
import os

app = Flask(__name__)

def get_pod_details():
    # Load the in-cluster Kubernetes configuration
    config.load_incluster_config()

    # Create an instance of the CoreV1Api
    v1 = client.CoreV1Api()

    # Get the current namespace and pod name from environment variables
    namespace = os.getenv('POD_NAMESPACE', 'default')
    pod_name = os.getenv('POD_NAME', 'unknown')

    # Fetch details of the current pod
    try:
        pod = v1.read_namespaced_pod(name=pod_name, namespace=namespace)
        pod_info = {
            'name': pod.metadata.name,
            'namespace': pod.metadata.namespace,
            'ip': pod.status.pod_ip,
            'node_name': pod.spec.node_name
        }
        return pod_info
    except client.exceptions.ApiException as e:
        return {'error': f"Exception when calling CoreV1Api->read_namespaced_pod: {e}"}

@app.route('/')
def index():
    pod_details = get_pod_details()
    return jsonify(pod_details)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)