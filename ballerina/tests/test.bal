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
import ballerina/oauth2;
import ballerina/test;

configurable boolean isLiveServer = false;
configurable string clientId = "clientId";
configurable string clientSecret = "clientSecret";
configurable string refreshToken = "refreshToken";

final Client hubSpotClient = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId,
            clientSecret,
            refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, "https://api.hubapi.com/crm/v3/objects/calls");
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, "http://localhost:9090");
}

const string HS_OWNER_ID = "77367788"; // example owner id
const string HS_OBJECT_ID = "83829237490"; // example contact id
const int:Signed32 HS_ASSOCIATION_TYPE_ID = 194; // call to contact association

isolated string hsCallId = "";
isolated string[] hsBatchCallIds = [];

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testPostACall() returns error? {
    SimplePublicObjectInputForCreate payload = {
        properties: {
            hs_timestamp: "2025-02-17T01:32:44.872Z",
            hs_call_title: "Support call",
            hubspot_owner_id: HS_OWNER_ID,
            hs_call_body: "Resolved issue",
            hs_call_duration: "3800",
            hs_call_from_number: "(857) 829 5489",
            hs_call_to_number: "(509) 999 9999",
            hs_call_recording_url: "example.com/recordings/abc",
            hs_call_status: "COMPLETED"
        },
        associations: [
            {
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: HS_ASSOCIATION_TYPE_ID
                    }
                ],
                to: {
                    id: HS_OBJECT_ID
                }
            }
        ]
    };

    SimplePublicObject response = check hubSpotClient->/.post(payload);
    test:assertTrue(response.createdAt != "", "Call creation failed");

    lock {
        hsCallId = response.id;
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testPostACallNegative() returns error? {
    SimplePublicObjectInputForCreate payload = {
        properties: {
            hs_timestamp: "2025-02-17T01:32:44.872Z",
            hs_call_title: "Support call",
            hubspot_owner_id: HS_OWNER_ID,
            hs_call_body: "Resolved issue",
            hs_call_duration: "3800",
            hs_call_from_number: "(857) 829 5489",
            hs_call_to_number: "(509) 999 9999",
            hs_call_recording_url: "example.com/recordings/abc",
            hs_call_status: "COMPLETED"
        },
        associations: [
            {
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 75 // Invalid associationTypeId to trigger an error
                    }
                ],
                to: {
                    id: HS_OBJECT_ID
                }
            }
        ]
    };

    SimplePublicObject|error response = hubSpotClient->/.post(payload);

    test:assertTrue(response is error, "Expected an error response for invalid associationTypeId");
}

@test:Config {
    dependsOn: [testPostACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCalls() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubSpotClient->/.get();
    test:assertTrue(response.results.length() > 0, "No calls found");
}

@test:Config {
    dependsOn: [testPostACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetACallById() returns error? {
    string callId = "";
    lock {
        callId = hsCallId;
    }

    SimplePublicObject response = check hubSpotClient->/[callId].get();
    test:assertTrue(response.id == callId, "Call id mismatch");
}

@test:Config {
    dependsOn: [testArchiveACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetACallByIdNegative() returns error? {
    string callId = "invalid_call_id";

    SimplePublicObject|error response = hubSpotClient->/[callId].get();

    test:assertTrue(response is error, "Call is not archived");
}

@test:Config {
    dependsOn: [testPostACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testSearchCalls() returns error? {
    PublicObjectSearchRequest payload = {
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "hs_call_title",
                        operator: "EQ",
                        value: "Support call"
                    }
                ]
            }
        ],
        sorts: ["hs_createdate DESCENDING"],
        'limit: 10,
        after: "0"
    };

    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check hubSpotClient->/search.post(payload);

    test:assertTrue(response.results.length() > 0, "No calls found");
}

@test:Config {
    enable: isLiveServer,
    dependsOn: [testPostACall],
    groups: ["live_tests"]
}
isolated function testSearchCallsNegative() returns error? {
    PublicObjectSearchRequest payload = {
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "invalid_property", // Invalid property to trigger an error
                        operator: "EQ",
                        value: "Non-existent value"
                    }
                ]
            }
        ],
        sorts: ["hs_createdate DESCENDING"],
        'limit: 10,
        after: "0"
    };

    CollectionResponseWithTotalSimplePublicObjectForwardPaging|error response = hubSpotClient->/search.post(payload);

    test:assertTrue(response is error, "Expected an error response for invalid search filter");
}

@test:Config {
    dependsOn: [testPostACall, testGetACallById, testSearchCalls],
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateACall() returns error? {
    string callId = "";
    lock {
        callId = hsCallId;
    }

    SimplePublicObjectInput payload = {
        properties: {
            hs_timestamp: "2025-02-17T01:32:44.872Z",
            hs_call_title: "Support call",
            hubspot_owner_id: HS_OWNER_ID,
            hs_call_body: "Resolved issue: updated",
            hs_call_duration: "3800",
            hs_call_from_number: "(857) 829 5489",
            hs_call_to_number: "(509) 999 9999",
            hs_call_recording_url: "example.com/recordings/abc",
            hs_call_status: "COMPLETED"
        }
    };

    SimplePublicObject|error response = hubSpotClient->/[callId].patch(payload);

    if response is SimplePublicObject {
        test:assertTrue(response.properties?.hs_call_body == "Resolved issue: updated", "Call body is not updated");
    } else {
        test:assertTrue(false, "Response is not in correct type");
    }
}

@test:Config {
    dependsOn: [testUpdateACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateACallNegative() returns error? {
    string callId = "";
    lock {
        callId = hsCallId;
    }

    SimplePublicObjectInput payload = {
        properties: {
            hs_timestamp: "2025-02-17T01:32:44.872Z",
            hs_call_title: "Support call",
            hubspot_owner_id: HS_OWNER_ID,
            hs_call_body: "Resolved issue: invalid update",
            hs_call_duration: "3800",
            hs_call_from_number: "(857) 829 5489",
            hs_call_to_number: "(509) 999 9999",
            hs_call_recording_url: "example.com/recordings/abc",
            hs_call_status: "INVALID_STATUS" // Invalid status to trigger an error
        }
    };

    SimplePublicObject|error response = hubSpotClient->/[callId].patch(payload);

    test:assertTrue(response is error, "Expected an error response for invalid update");
}

@test:Config {
    dependsOn: [testUpdateACall, testPostACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testArchiveACall() returns error? {
    string callId = "";
    lock {
        callId = hsCallId;
    }

    http:Response response = check hubSpotClient->/[callId].delete();

    test:assertEquals(response.statusCode, 204, "Call deletion failed");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchCreateCalls() returns error? {
    BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: [
            {
                properties: {
                    hs_timestamp: "2025-02-17T01:32:44.872Z",
                    hs_call_title: "Support call 1",
                    hubspot_owner_id: HS_OWNER_ID,
                    hs_call_body: "Resolved issue 1",
                    hs_call_duration: "3800",
                    hs_call_from_number: "(857) 829 5489",
                    hs_call_to_number: "(509) 999 9999",
                    hs_call_recording_url: "example.com/recordings/abc1",
                    hs_call_status: "COMPLETED"
                },
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: HS_ASSOCIATION_TYPE_ID
                            }
                        ],
                        to: {
                            id: HS_OBJECT_ID
                        }
                    }
                ]
            },
            {
                properties: {
                    hs_timestamp: "2025-02-17T01:32:44.872Z",
                    hs_call_title: "Support call 2",
                    hubspot_owner_id: HS_OWNER_ID,
                    hs_call_body: "Resolved issue 2",
                    hs_call_duration: "3800",
                    hs_call_from_number: "(857) 829 5489",
                    hs_call_to_number: "(509) 999 9999",
                    hs_call_recording_url: "example.com/recordings/abc2",
                    hs_call_status: "COMPLETED"
                },
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: HS_ASSOCIATION_TYPE_ID
                            }
                        ],
                        to: {
                            id: HS_OBJECT_ID
                        }
                    }
                ]
            }
        ]
    };

    BatchResponseSimplePublicObject response = check hubSpotClient->/batch/create.post(payload);

    test:assertTrue(response.results.length() == 2, "Batch create did not return expected number of results");

    foreach SimplePublicObject obj in response.results {
        test:assertTrue(obj.createdAt != "", "Call creation failed");
    }

    lock {
        var ids = response.cloneReadOnly().results.map(isolated function(SimplePublicObject result) returns string {
            return result.id;
        });

        hsBatchCallIds = ids.cloneReadOnly();
    }
}

@test:Config {
    dependsOn: [testBatchCreateCalls],
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchReadCalls() returns error? {
    string[] callIds;
    lock {
        callIds = hsBatchCallIds.cloneReadOnly();
    }

    BatchReadInputSimplePublicObjectId payload = {
        inputs: callIds.map(isolated function(string id) returns SimplePublicObjectId {
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

    BatchResponseSimplePublicObject response = check hubSpotClient->/batch/read.post(payload);

    test:assertTrue(response.results.length() == 2, "Batch read did not return expected number of results");
}

@test:Config {
    dependsOn: [testBatchReadCalls],
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchUpdateCalls() returns error? {
    string[] callIds;
    lock {
        callIds = hsBatchCallIds.cloneReadOnly();
    }

    BatchInputSimplePublicObjectBatchInput payload = {
        inputs: callIds.map(isolated function(string id) returns SimplePublicObjectBatchInput {
            return {
                id: id,
                properties: {
                    hs_call_body: "Updated call body"
                }
            };
        })
    };

    BatchResponseSimplePublicObject response = check hubSpotClient->/batch/update.post(payload);

    test:assertTrue(response.results.length() == callIds.length(), "Batch update did not return expected number of results");

    foreach var result in response.results {
        test:assertTrue(result.properties?.hs_call_body == "Updated call body", "Call body is not updated");
    }
}

@test:Config {
    dependsOn: [testBatchUpdateCalls],
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchArchiveCalls() returns error? {
    string[] callIds;
    lock {
        callIds = hsBatchCallIds.cloneReadOnly();
    }

    BatchReadInputSimplePublicObjectId payload = {
        inputs: callIds.map(isolated function(string id) returns SimplePublicObjectId {
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

    http:Response response = check hubSpotClient->/batch/archive.post(payload);

    test:assertEquals(response.statusCode, 204, "Batch archive failed");
}
