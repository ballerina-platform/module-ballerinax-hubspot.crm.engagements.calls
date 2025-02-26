# Examples

The `ballerinax/hubspot.crm.engagements.calls` connector provides practical examples illustrating usage in various scenarios.

1. [Call for Contact](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/tree/main/examples/call-for-contact) - Operations on a single call such as creating, updating, and deleting, as well as getting a list of available calls and searching for a call by its content.

2. [Manage Batch Of Calls for Contacts](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.calls/tree/main/examples/manage-batch-of-calls) - Operations on a batch of calls such as creating, updating, and deleting, as well as getting calls by their ID.

## Prerequisites

- Ballerina Swan Lake Update 11 (2201.11.0)
- A HubSpot account with necessary API permissions
- OAuth2 credentials (Client ID, Client Secret, and Refresh Token)

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
