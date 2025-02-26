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

import ballerina/http;
import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.engagements.calls as hsCalls;

// Variables required for authentication
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

// example IDs for testing
final string ownerId = "77367788";
final string contactId = "83829237490";

hsCalls:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};
final hsCalls:Client hubspotClientCalls = check new ({auth});

public function main() returns error? {
    // Batch create calls
    io:println("Batch creating calls...");

    hsCalls:BatchInputSimplePublicObjectInputForCreate payloadCreate = {
        inputs: [
            {
                properties: {
                    "hs_timestamp": "2025-02-17T01:32:44.872Z",
                    "hs_call_title": "Support call 1",
                    "hubspot_owner_id": ownerId,
                    "hs_call_body": "Resolved issue 1",
                    "hs_call_duration": "3800",
                    "hs_call_from_number": "(857) 829 5489",
                    "hs_call_to_number": "(509) 999 9999",
                    "hs_call_recording_url": "example.com/recordings/abc1",
                    "hs_call_status": "IN_PROGRESS"
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
                            id: contactId
                        }
                    }
                ]
            },
            {
                properties: {
                    "hs_timestamp": "2025-02-17T01:32:44.872Z",
                    "hs_call_title": "Support call 2",
                    "hubspot_owner_id": ownerId,
                    "hs_call_body": "Resolved issue 2",
                    "hs_call_duration": "3800",
                    "hs_call_from_number": "(857) 829 5489",
                    "hs_call_to_number": "(509) 999 9999",
                    "hs_call_recording_url": "example.com/recordings/abc2",
                    "hs_call_status": "IN_PROGRESS"
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
                            id: contactId
                        }
                    }
                ]
            }
        ]
    };

    hsCalls:BatchResponseSimplePublicObject responseCreate = check hubspotClientCalls->/batch/create.post(payloadCreate);

    // Extract call IDs for further operations
    string[] callIds = responseCreate.results.map(function(hsCalls:SimplePublicObject call) returns string {
        io:println("Created call: ", call.id, ", Status: ", call.properties["hs_call_status"]);
        return call.id;
    });

    // Batch read calls
    io:println("\nBatch reading calls...");

    hsCalls:BatchReadInputSimplePublicObjectId payloadRead = {
        inputs: callIds.map(function(string id) returns hsCalls:SimplePublicObjectId {
            return {"id": id};
        }),
        properties: [
            "hs_createdate",
            "hs_call_title"
        ],
        propertiesWithHistory: [
            "hs_call_status"
        ]
    };

    hsCalls:BatchResponseSimplePublicObject responseRead = check hubspotClientCalls->/batch/read.post(payloadRead);
    foreach hsCalls:SimplePublicObject call in responseRead.results {
        io:println("Call ID: ", call.id, ", Title: ", call.properties["hs_call_title"]);
    }

    // Batch update calls
    io:println("\nBatch updating calls...");

    hsCalls:BatchInputSimplePublicObjectBatchInput payloadUpdate = {
        inputs: callIds.map(function(string id) returns hsCalls:SimplePublicObjectBatchInput {
            return {
                id: id,
                properties: {
                    "hs_call_title": "Updated call title for " + id,
                    "hs_call_status": "COMPLETED"
                }
            };
        })
    };

    hsCalls:BatchResponseSimplePublicObject responseUpdate = check hubspotClientCalls->/batch/update.post(payloadUpdate);
    foreach hsCalls:SimplePublicObject call in responseUpdate.results {
        io:println("Updated call: ", call.id, ", Title: ", call.properties["hs_call_title"], ", Status: ", call.properties["hs_call_status"]);
    }

    // Batch archive calls
    io:println("\nBatch archiving calls...");

    hsCalls:BatchReadInputSimplePublicObjectId payloadArchive = {
        inputs: callIds.map(function(string id) returns hsCalls:SimplePublicObjectId {
            return {id: id};
        }),
        properties: [
            "hs_createdate",
            "hs_call_title"
        ],
        propertiesWithHistory: [
            "hs_call_status"
        ]
    };

    http:Response responseArchive = check hubspotClientCalls->/batch/archive.post(payloadArchive);
    io:println("Batch archive response status code: ", responseArchive.statusCode);
}
