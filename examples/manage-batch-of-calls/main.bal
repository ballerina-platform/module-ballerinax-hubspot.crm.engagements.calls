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
    // Batch create calls
    io:println("Batch creating calls...");

    hscalls:BatchInputSimplePublicObjectInputForCreate payloadCreate = {
        inputs: [
            {
                properties: {
                    "hs_timestamp": "2025-02-17T01:32:44.872Z",
                    "hs_call_title": "Support call 1",
                    "hubspot_owner_id": OWNER_ID,
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
                            id: CONTACT_ID
                        }
                    }
                ]
            },
            {
                properties: {
                    "hs_timestamp": "2025-02-17T01:32:44.872Z",
                    "hs_call_title": "Support call 2",
                    "hubspot_owner_id": OWNER_ID,
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
                            id: CONTACT_ID
                        }
                    }   
                ]
            }
        ]
    };

    hscalls:BatchResponseSimplePublicObject responseCreate = check hubspotClientCalls->/batch/create.post(payloadCreate);
    foreach hscalls:SimplePublicObject call in responseCreate.results {
        io:println(string `Created call: ${call.id}, Status: ${call.properties["hs_call_status"] ?: "Not Found!"}`);
    }
    
    string[] callIds = from hscalls:SimplePublicObject callId in responseCreate.results select callId.id;

    // Batch read calls
    io:println("\nBatch reading calls...");

    hscalls:BatchReadInputSimplePublicObjectId payloadRead = {
        inputs: from string callId in callIds select {
            id: callId
        },
        properties: [
            "hs_createdate",
            "hs_call_title"
        ],
        propertiesWithHistory: [
            "hs_call_status"
        ]
    };

    hscalls:BatchResponseSimplePublicObject responseRead = check hubspotClientCalls->/batch/read.post(payloadRead);
    foreach hscalls:SimplePublicObject call in responseRead.results {
        io:println(string `Call ID: ${call.id}, Title: ${call.properties["hs_call_title"] ?: "Not Found!"}`);
    }

    // Batch update calls
    io:println("\nBatch updating calls...");

    hscalls:BatchInputSimplePublicObjectBatchInput payloadUpdate = {
        inputs: from string callId in callIds select {
            id: callId,
            properties: {
                "hs_call_title": string `Updated call title for ${callId}`,
                "hs_call_status": "COMPLETED"
            }
        }
    };

    hscalls:BatchResponseSimplePublicObject responseUpdate = check hubspotClientCalls->/batch/update.post(payloadUpdate);
    foreach hscalls:SimplePublicObject call in responseUpdate.results {
        io:println(string `Updated call: ${call.id}, Title: ${call.properties["hs_call_title"] ?: "Not Found!"}, Status: ${call.properties["hs_call_status"] ?: ""}`);
    }

    // Batch archive calls
    io:println("\nBatch archiving calls...");

    hscalls:BatchReadInputSimplePublicObjectId payloadArchive = {
        inputs: from string callId in callIds select {
            id: callId
        },
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
