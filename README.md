# Pulling a Private DockerHub Image with Helm in Kubernetes

Containerization has revolutionized how we build, ship, and run applications. Docker packages our code into portable containers, Kubernetes orchestrates them at scale, and Helm simplifies the deployment process with reusable charts. But what happens when your Docker images live in a private registry? In this guide, I’ll walk you through pulling a private DockerHub image into a Kubernetes cluster using Helm—tested locally on my MacBook Air with Minikube.

Whether you’re a DevOps newbie or a seasoned engineer, this tutorial will show you how to securely deploy a Node.js app from a private DockerHub repository. Let’s dive in!

---

## What You’ll Learn
- How to dockerize a Node.js application.
- How to push an image to a private DockerHub registry.
- How to configure Kubernetes to pull that image using Helm.
- How to run it locally with Minikube and access it in your browser.

---

## Prerequisites
- **Docker Desktop**: Installed and running on your machine (includes Kubernetes support).
- **Minikube**: For a local Kubernetes cluster ([installation guide](https://minikube.sigs.k8s.io/docs/start/)).
- **Helm**: The Kubernetes package manager ([installation guide](https://helm.sh/docs/intro/install/)).
- **kubectl**: To interact with Kubernetes.
- **DockerHub Account**: For hosting your private image.
- A basic understanding of Docker and Kubernetes.

I’ll assume you’re working on a macOS system like mine (arm64), but these steps are adaptable to Linux or Windows with minor tweaks.

---

## Step 1: Dockerizing a Node.js App

Let’s start by creating a simple Node.js app and turning it into a Docker image.

### 1.1 Create the Project
Open your terminal and set up a new directory:
```bash
mkdir express_app && cd express_app
```

### 1.2 Define Dependencies
Create a `package.json` file:
```bash
nano package.json
```
Add this content:
```json
{
  "name": "docker-example",
  "version": "1.0.0",
  "description": "A Node.js app in Docker",
  "main": "app.js",
  "scripts": {
    "start": "nodemon app.js"
  },
  "author": "Navneet Shahi",
  "license": "ISC",
  "dependencies": {
    "express": "^4.17.1",
    "nodemon": "^2.0.12"
  }
}
```
Save and exit (`Ctrl+X`, `Shift+Y`, `Enter`).

Install the dependencies:
```bash
npm install
```

### 1.3 Write the App
Create `app.js`:
```bash
nano app.js
```
Add:
```javascript
const express = require('express');
const app = express();

const msg = "Hello world! This is Node.js in a Docker container.";
app.get('/', (req, res) => res.send(msg));

app.listen(3000, () => {
  console.log("App running on port 3000...");
});
```
Save and exit.

Test it locally:
```bash
npm run start
```
Visit `http://localhost:3000` in your browser—you should see the “Hello world!” message.

### 1.4 Build the Docker Image
Create a `Dockerfile`:
```bash
nano Dockerfile
```
Add:
```dockerfile
FROM node:latest
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
CMD ["npm", "start"]
EXPOSE 3000
```
Save and exit.

Build the image:
```bash
docker build -t nodeapp .
```
Verify it:
```bash
docker images
```

Run it as a container:
```bash
docker run -p 3000:3000 nodeapp
```
Check `http://localhost:3000` again to confirm it works.

---

## Step 2: Push to a Private DockerHub Registry

Now, let’s push this image to your private DockerHub repository.

### 2.1 Log In to DockerHub
```bash
docker login
```
Enter your DockerHub username (e.g., `navneet`) and password.

### 2.2 Tag the Image
Tag your image with your DockerHub username:
```bash
docker tag nodeapp:latest navneet/nodeapp:latest
```
Replace `navneet` with your actual username.

### 2.3 Push the Image
```bash
docker push navneet/nodeapp:latest
```
Once complete, log in to DockerHub and confirm your private repository shows the `nodeapp:latest` image.

---

## Step 3: Set Up Minikube

Since we’re avoiding cloud providers like EKS, let’s use Minikube for a local Kubernetes cluster.

Start Minikube:
```bash
minikube start --driver=docker
```
Verify it’s running:
```bash
kubectl get nodes
```

---

## Step 4: Pull the Image with Helm

### 4.1 Create a Docker Registry Secret
Kubernetes needs credentials to pull from your private registry. Create a secret:
```bash
kubectl create secret docker-registry nodeapp \
    --docker-server=https://index.docker.io/v1/ \
    --docker-username=navneet \
    --docker-password=your-password
```
Replace `your-password` with your DockerHub password or an access token (recommended for security).

Verify:
```bash
kubectl get secrets
```

### 4.2 Create a Helm Chart
Generate a Helm chart:
```bash
helm create nodejs
cd nodejs
```

Edit `values.yaml`:
```bash
nano values.yaml
```
Update these key sections:
```yaml
replicaCount: 1

image:
  repository: navneet/nodeapp
  pullPolicy: IfNotPresent
  tag: "latest"

imagePullSecrets:
  - name: nodeapp

service:
  type: NodePort
  port: 3000
```
Save and exit.

### 4.3 Install the Chart
Deploy the app:
```bash
helm install mynodeapp .
```

Check the pods:
```bash
kubectl get pods
```
You should see something like `mynodeapp-nodejs-5ff796967c-xxxxx`.

Inspect the pod to confirm the image was pulled:
```bash
kubectl describe pod <pod-name>
```
Look under “Containers” for `navneet/nodeapp:latest`.

---

## Step 5: Access the App

### 5.1 Expose the Service
Get the service details:
```bash
kubectl get svc
```

Forward the port to your local machine:
```bash
kubectl port-forward --address 0.0.0.0 svc/mynodeapp-nodejs 3000:3000
```

### 5.2 Open in Browser
With Minikube, get the IP:
```bash
minikube ip
```
Visit `http://<minikube-ip>:3000` in your browser. You should see:
```
Hello world! This is Node.js in a Docker container.
```

---

## Troubleshooting Tips
- **Image Pull Fails**: Double-check your secret credentials and `imagePullSecrets` in `values.yaml`.
- **Pod Crashing**: Use `kubectl logs <pod-name>` to debug.
- **Minikube Issues**: Restart with `minikube delete && minikube start`.

---

## Conclusion

Pulling a private DockerHub image into Kubernetes with Helm is a breeze once you connect the dots: a Docker registry secret for authentication and a Helm chart to define your deployment. This setup ensures secure, repeatable deployments—whether you’re testing locally with Minikube or scaling in production.

For your next step, try enhancing this chart with ingress or autoscaling—or share your own twist in the comments! If you found this helpful, clap for it on Medium and follow me for more DevOps adventures.


