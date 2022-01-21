# Introduction

## Projects

### WeatherApp

.NET Core Web Application that gets weather information from an API and displays them to the user.

Will display the location of the Web Application e.g. Azure Container Instances, Azure App Services for Containers, and the location of the data returned in the API call.

### WeatherApi

.NET Core Web Application that returns weather information and the location of the data, e.g. Azure Container Instances, Azure App Services for Containers, etc.

## Notes

Will deploy to Azure using GitHub Actions.

Will deploy infrastructure using Bicep templates.

Will create the infrastructure prior, but important to share the templates if users want to deploy it to themselves.

Deployment locations include:

- [ ] Azure Container Instances
- [ ] Azure App Services for Containers
- [ ] Azure Kubernetes Services
- [ ] Azure Container Apps

Answer the question why would you use each platform? The pros and cons.

Should be demo intensive.

From the end user perspective, build a rubric/flowchart.

One build pipeline, and then six deployment pipelines.

### Bonus

"DAPRize" AKS and Container Apps ... communication between the front end and the back end.

Thanks to <https://github.com/roberto-mardeni/azure-containers-demo> for the inspiration.
