# ClassCharts API Server

Rewrite of the ClassCharts API server, built in [Swift](https://www.swift.org/).

It's working to be 100% compliant with the Student & Parent API.

## Getting Started

### Creating a `.env`

```sh
JWT_SECRET=(openssl rand -base64 40)
```

### Seeding the SQLite Database

```sh
swift run ClassChartsAPIServer seed
```

### Starting the development server

```sh
swift run
```
