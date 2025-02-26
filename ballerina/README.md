## Overview

The `ballerinax/hubspot.crm.engagements.calls` connector offers APIs to connect and interact with the [Hubspot CRM Engagements Calls API](https://developers.hubspot.com/docs/guides/api/crm/engagements/calls) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api/overview).

## Setup guide

### Step 1: Create/login to a HubSpot developer account

If you already have a HubSpot Developer Account, go to the [HubSpot developer portal](https://app.hubspot.com/).

If you don't have an account, you can sign up for a free account [here](https://developers.hubspot.com/get-started).

### Step 2: Create a HubSpot app

1. Now navigate to the `Apps` section from the left sidebar and click on the `Create app` button on the top right corner.

   ![Create app image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/5_create_app.png)

2. Provide a public app name and description for your app.

   ![App name description image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/6_app_name_description.png)

### Step 3: Set up authentication

1. Move to the `Auth` tab.

   ![Config auth image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/7_config_auth.png)

2. Then scroll down to the `Scopes` section and click on the `Add new scopes` button to add the scopes.

   ![Config scopes image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/8_config_scopes.png)

3. Add the following scopes and click on the `Update` button.

   - `crm.objects.contacts.read`
   - `crm.objects.contacts.write`

   ![Add scopes image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/9_add_scopes.png)

4. In the `Redirect URL` section, add the redirect URL for your app. This is the URL where the user will be redirected after the authentication process. You can use localhost for testing purposes. Then hit the `Create App` button.

   ![Redirect URL image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/10_redirect_url.png)

### Step 4: Get the client ID and client secret

Navigate to the `Auth` tab and you will see the `Client ID` and `Client Secret` for your app. Make sure to save these values.

![Client ID secret image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/11_client_id_secret.png)

### Step 5: Set up authentication flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```url
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>`, and `<YOUR_SCOPES>` with your specific values.

2. Paste it in the browser and select your developer test account to install the app when prompted.

   ![HubSpot auth config screen image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/12-hubspot_auth_config_screen.png)

3. A code will be displayed in the browser. Copy the code.

4. Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>`, and `<YOUR_CLIENT_SECRET>` with your specific values. Use the code you received in the above step 3 as the `<CODE>`.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

5. Store the access token securely for use in your application.

### Step 6 (Optional): Create a developer test account under your account

Within app developer accounts, you can create a [Developer Test Account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) to test apps and integrations without affecting any real HubSpot data.

 > **Note:** These accounts are only for development and testing purposes. In production, you should not use Developer Test Accounts.

1. Go to the `Test accounts` section from the left sidebar.

   ![Test account image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/1_test_account.png)

2. Click on the `Create developer test account` button on the top right corner.

   ![Create test account image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/2_create_test_account.png)

3. In the pop-up window, provide a name for the test account and click on the `Create` button.

   ![Create account image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/3_create_account.png)

4. You will see the newly created test account in the list of test accounts.

   ![Test account portal image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/main/docs/setup/resources/4_test_account_portal.png)

## Quickstart

To use the `HubSpot CRM Engagement Calls` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.engagements.calls` module and `oauth2` module.

```ballerina
import ballerinax/hubspot.crm.engagements.calls as hscalls;
import ballerina/oauth2;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the obtained credentials in the above steps as follows:

   ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
   ```

2. Instantiate a `OAuth2RefreshTokenGrantConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina
    configurable string clientId = ?;
    configurable string clientSecret = ?;
    configurable string refreshToken = ?;

    OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };

    ConnectionConfig config = {auth:auth};
    final hscalls:Client hubspot  = check new(config);
    ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample use case is shown below.

#### Read all Calls

```ballerina
public function main() returns error? {
   hscalls:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging pageOfCalls = check hubspot->/.get();
   io:println("Calls: ", pageOfCalls);
}
```

## Examples

The `HubSpot CRM Engagements Calls` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/tree/main/examples), covering the following use cases:

1. [Call for contacts](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/tree/main/examples/call-for-contact) - This example demonstrate the operations on a single call such as creating, updating, and deleting, as well as getting a list of available calls and searching for a call by its content.

2. [Manage batch of calls for contacts](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/tree/main/examples/manage-batch-of-calls) - This example demonstrate operations on a batch of calls such as creating, updating, and deleting, as well as getting calls by their ID.
