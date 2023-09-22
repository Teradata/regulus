# Deploy with Docker Compose

## Workspaces

### With AWS

```
docker compose -f workspaces.yaml -f aws.yaml 
```
### With Azure
```
docker compose -f workspaces.yaml -f azure.yaml 
```

## Jupyter

```
docker compose -f jupyter.yaml up
```
## Jupyter and Workspaces

### With AWS

```
docker compose -f workspaces.yaml -f aws.yaml -f jupyter.yaml up
```

### With Azure

```
docker compose -f workspaces.yaml -f azure.yaml -f jupyter.yaml up
```

### With Aws and Azure

```
docker compose -f workspaces.yaml -f aws.yaml -f azure.yaml -f jupyter.yaml up
```