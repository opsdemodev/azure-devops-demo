from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <html>
    <body>
        <h1>Azure DevOps Demo</h1>
        <h2>GitHub → Jenkins → Docker → ACR → Azure Container Apps</h2>
        <p>Application deployed successfully!</p>
    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
