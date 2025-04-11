// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.engagements.calls as hscalls;

// Variables required for authentication
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

// example IDs for testing
const string OWNER_ID = "77367788";
const string CONTACT_ID = "83829237490";

hscalls:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};
final hscalls:Client hubspotClientCalls = check new ({auth});

public function main() returns error? {
    // create a new call
    io:println("Creating a new call...");

    hscalls:SimplePublicObjectInputForCreate payloadCreate = {
        properties: {
            "hsTimestamp": "2025-02-17T01:32:44.872Z",
            "hsCallTitle": "Support call",
            "hubspotOwnerId": OWNER_ID,
            "hsCallBody": "Resolved issue",
            "hsCallDuration": "3800",
            "hsCallFromNumber": "(857) 829 5489",
            "hsCallToNumber": "(509) 999 9999",
            "hsCallRecordingUrl": "example.com/recordings/abc",
            "hsCallStatus": "IN_PROGRESS"
        },
        associations: [
            {
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 194
                    }
                ],
                to: {
                    id: CONTACT_ID
                }
            }
        ]
    };

    hscalls:SimplePublicObject responseCreated = check hubspotClientCalls->/.post(payloadCreate);
    string callId = responseCreated.id;
    io:println("Call created successfully with ID: ", callId);

    // get all calls
    io:println("\nGetting all calls...");

    hscalls:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging responseGetAll = check hubspotClientCalls->/.get();
    io:println("All calls:");
    foreach hscalls:SimplePublicObjectWithAssociations call in responseGetAll.results {
        io:println("ID: ", call.id);
    }

    // update the call
    io:println("\nUpdating the call...");

    hscalls:SimplePublicObjectInput payloadUpdate = {
        properties: {
            "hsCallTitle": "Support call Updated",
            "hsCallBody": "Resolved issue: updated",
            "hsCallStatus": "COMPLETED"
        }
    };

    hscalls:SimplePublicObject responseUpdated = check hubspotClientCalls->/[callId].patch(payloadUpdate);
    io:println("Call updated successfully with ID: ", responseUpdated.id);
    io:println("Updated status: ", responseUpdated.properties["hsCallStatus"]);

    // archive the call
    io:println("\nArchive the call...");

    error? responseArchive = check hubspotClientCalls->/[callId].delete();
    io:println("Call archived successfully with status code: ", responseArchive);
}
