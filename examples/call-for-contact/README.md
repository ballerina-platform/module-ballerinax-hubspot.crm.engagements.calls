
# Call For Contact Example

This example demonstrates how to use the `ballerinax/hubspot.crm.engagements.calls` module to create, retrieve, update, and archive a call in HubSpot CRM.

## Overview

The `main.bal` file contains a Ballerina program that performs the following operations:

1. Creates a new call associated with a contact.
2. Retrieves all calls.
3. Updates the created call.
4. Archives the updated call.

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

1. Navigate to the Ballerina package directory.
2. Run the Ballerina program using the following command:

```sh
bal run
```

You should see the output of each operation (create, retrieve, update, archive) in the console.
