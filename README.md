# Kubernetes Community Days Spain 2025

## Develop

To develop, you need first time to go to #buid stage (only one tieme) and then just run this command and open your browser at http://localhost:1313. When making changes in the code, the website will be automatically regenerated. You just need to refresh the browser.

```bash
docker run -it --rm --name cn2025 \
  -v $(pwd)/:/app \
  -p 1313:1313 \
  cn:2025
```

## Build

We have containerized the CNSpain 2025 webpage. To avoid compatibility problems and versions mismatch you can execute and run the website using docker/podman. To do so, make sure you have initialized and pulled the submodules.

```bash
git submodule update --init --force
docker build -t cn:2025 .
```

## Execute

To execute and serve the website you can run the following command, remember hugo uses the port 1313.

```bash
docker run -p 1313:1313 cn:2025
```