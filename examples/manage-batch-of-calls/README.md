# Manage Batch Of Calls Example

This example demonstrates how to use the `ballerinax/hubspot.crm.engagements.calls` module to batch create, read, update, and archive calls in HubSpot CRM.

## Overview

The `main.bal` file contains a Ballerina program that performs the following operations:

1. Batch creates multiple calls.
2. Batch reads the created calls.
3. Batch updates the created calls.
4. Batch archives the updated calls.

## Prerequisites

- Ballerina Swan Lake Update 11 (2201.11.0)
- A HubSpot account with necessary API permissions
- OAuth2 credentials (Client ID, Client Secret, and Refresh Token)

## Configuration

Create a `Config.toml` file in the same directory as `main.bal` and add the following configurations:

```toml
clientId = "<your_client_id>"
clientSecret = "<your_client_secret>"
refreshToken = "<your_refresh_token>"
```

Replace `<your_client_id>`, `<your_client_secret>`, and `<your_refresh_token>` with your actual HubSpot OAuth2 credentials.

## Running the Example

1. Navigate to the directory containing `main.bal`.
2. Run the Ballerina program using the following command:

```sh
bal run
```

You should see the output of each operation (batch create, read, update, archive) in the console.
