
# Easypay

Easypay is a pay-later application that allows users to recharge their prepaid mobile talk, data, and SMS plans using available credits. Users can pay their bills once every 15 days, giving them flexibility in managing their mobile expenses. The entire project is containerized using **Podman**, making it easy to set up and run locally.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Environment Setup](#environment-setup)
- [Running the Application](#running-the-application)
- [Services](#services)
- [Accessing Databases](#accessing-databases)
- [Technologies Used](#technologies-used)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites
Before setting up the project locally, ensure you have the following installed:
- [Podman](https://podman.io/)
- [Podman Compose](https://github.com/containers/podman-compose)

## Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/sh3ll3y/easypay.git
    cd easypay
    ```

2. **Create the required configuration files**:
    In the root folder of the project (beside the `podman-compose.yml` file), create the following two files:

    - **`.env`** file:
        ```bash
        touch .env
        ```

        Add the following content to `.env`:
        ```bash
        AWS_ACCESS_KEY_ID=your_id_here
        AWS_SECRET_ACCESS_KEY=your_key_here
        ```

    - **`aws_config.yml`** file:
        ```bash
        touch aws_config.yml
        ```

        Add the following content to `aws_config.yml`:
        ```yaml
        AWS_ACCESS_KEY_ID: "your-id-here"
        AWS_SECRET_ACCESS_KEY: "your-key-here"
        S3_BUCKET: "your-bucket-name"
        AWS_REGION: "your-region"
        ```

3. **Add the configuration files to `.gitignore`**:
    Make sure to add these files to `.gitignore` to avoid exposing sensitive information:
    ```bash
    echo ".env" >> .gitignore
    echo "aws_config.yml" >> .gitignore
    ```

## Environment Setup

Once the configuration files are created, you are ready to set up the project environment.

1. **Build and run the services**:
    Use `podman-compose` to build and run all the services in detached mode:
    ```bash
    podman-compose up --build -d
    ```

2. The main application will be available at: 
    ```
    http://localhost:3000
    ```
    The notification service will run at:
    ```
    http://localhost:4567
    ```

## Services

The following services are containerized and run via **Podman**:

- **MySQL Database**: Handles the main application's and analytics' databases.
- **Redis**: Used for caching.
- **Rails App**: Main application running on `localhost:3000`.
- **Sidekiq**: Background job processing.
- **Notification Service**: Runs on `localhost:4567`.
- **Elasticsearch, Logstash, Kibana**: For search and logging.
- **Analytics Service (Named as Kafka-consumer)**: Runs to consume payments events to store them in analytics db.

## Accessing Databases

You can connect to the MySQL databases (both main and analytics databases) using any MySQL client, as the service runs on the default MySQL port (3306). The database credentials can be found in the environment variables in the `podman-compose.yml` file.

1. **Connect to MySQL Server**:
    ```bash
    mysql -h localhost -P 3306 -u root -p
    ```

## Technologies Used

- **Ruby on Rails**: Backend for the main application.
- **Podman**: For containerization and orchestration.
- **MySQL**: Relational database for application and analytics.
- **Redis**: In-memory data store for caching.
- **Elasticsearch, Logstash, Kibana (ELK Stack)**: For logging and search functionality.
- **Kafka**: For event-driven architecture (notifications).
- **Sidekiq**: For background job processing.


## License

Easypay is open-source and available under the [MIT License](LICENSE).

