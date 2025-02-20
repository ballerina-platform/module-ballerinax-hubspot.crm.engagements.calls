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

configurable boolean isLiveServer = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/objects/calls" : "http://localhost:9090";
final Client hubSpotClient = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, serviceUrl);
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, serviceUrl);
}

final string hs_owner_id = "77367788"; // example owner id
final string hs_object_id = "83829237490"; // example contact id
final int:Signed32 hs_association_type_id = 194; // call to contact association

isolated string hs_call_id = "";
isolated string[] hs_batch_call_ids = [];

// Test: Post a call
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testPostACall() returns error? {
    SimplePublicObjectInputForCreate payload = {
        properties: {
            "hs_timestamp": "2025-02-17T01:32:44.872Z",
            "hs_call_title": "Support call",
            "hubspot_owner_id": hs_owner_id,
            "hs_call_body": "Resolved issue",
            "hs_call_duration": "3800",
            "hs_call_from_number": "(857) 829 5489",
            "hs_call_to_number": "(509) 999 9999",
            "hs_call_recording_url": "example.com/recordings/abc",
            "hs_call_status": "COMPLETED"
        },
        associations: [
            {
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: hs_association_type_id
                    }
                ],
                to: {
                    id: hs_object_id
                }
            }
        ]
    };

    SimplePublicObject response = check hubSpotClient->/.post(payload);
    test:assertTrue(response.createdAt != "", "Call creation failed");

    lock {
        hs_call_id = response.id;
    }
}

// Test: (Negative) Post a call with invalid associationTypeId
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testPostACall_Negative() returns error? {
    SimplePublicObjectInputForCreate payload = {
        properties: {
            "hs_timestamp": "2025-02-17T01:32:44.872Z",
            "hs_call_title": "Support call",
            "hubspot_owner_id": hs_owner_id,
            "hs_call_body": "Resolved issue",
            "hs_call_duration": "3800",
            "hs_call_from_number": "(857) 829 5489",
            "hs_call_to_number": "(509) 999 9999",
            "hs_call_recording_url": "example.com/recordings/abc",
            "hs_call_status": "COMPLETED"
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
                    id: hs_object_id
                }
            }
        ]
    };

    SimplePublicObject|error response = hubSpotClient->/.post(payload);

    test:assertTrue(response is error, "Expected an error response for invalid associationTypeId");
}

// Test: Get calls
@test:Config {
    dependsOn: [testPostACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCalls() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubSpotClient->/.get();
    test:assertTrue(response.results.length() > 0, "No calls found");
}

// Test: Get a call by id
@test:Config {
    dependsOn: [testPostACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetACallById() returns error? {
    string call_id = "";
    lock {
        call_id = hs_call_id;
    }

    SimplePublicObject response = check hubSpotClient->/[call_id].get();
    test:assertTrue(response.id == call_id, "Call id mismatch");
}

// Test: (Nagative) Get a call by id
@test:Config {
    dependsOn: [testArchiveACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetACallById_Negative() returns error? {
    string call_id = "invalid_call_id";

    SimplePublicObject|error response = hubSpotClient->/[call_id].get();

    test:assertTrue(response is error, "Call is not archived");
}

// Test: Search calls
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

// Test: (Negative) Search calls with invalid filter
@test:Config {
    enable: isLiveServer,
    dependsOn: [testPostACall],
    groups: ["live_tests"]
}
isolated function testSearchCalls_Negative() returns error? {
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

// Test: Update a call
@test:Config {
    dependsOn: [testPostACall, testGetACallById, testSearchCalls],
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateACall() returns error? {
    string call_id = "";
    lock {
        call_id = hs_call_id;
    }

    SimplePublicObjectInput payload = {
        properties: {
            "hs_timestamp": "2025-02-17T01:32:44.872Z",
            "hs_call_title": "Support call",
            "hubspot_owner_id": hs_owner_id,
            "hs_call_body": "Resolved issue: updated",
            "hs_call_duration": "3800",
            "hs_call_from_number": "(857) 829 5489",
            "hs_call_to_number": "(509) 999 9999",
            "hs_call_recording_url": "example.com/recordings/abc",
            "hs_call_status": "COMPLETED"
        }
    };

    SimplePublicObject|error response = hubSpotClient->/[call_id].patch(payload);

    if response is SimplePublicObject {
        test:assertTrue(response.properties["hs_call_body"] == "Resolved issue: updated", "Call body is not updated");
    } else {
        test:assertTrue(false, "Response is not in correct type");
    }
}

// Test: (Negative) Update a call
@test:Config {
    dependsOn: [testUpdateACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateACall_Negative() returns error? {
    string call_id = "";
    lock {
        call_id = hs_call_id;
    }

    SimplePublicObjectInput payload = {
        properties: {
            "hs_timestamp": "2025-02-17T01:32:44.872Z",
            "hs_call_title": "Support call",
            "hubspot_owner_id": hs_owner_id,
            "hs_call_body": "Resolved issue: invalid update",
            "hs_call_duration": "3800",
            "hs_call_from_number": "(857) 829 5489",
            "hs_call_to_number": "(509) 999 9999",
            "hs_call_recording_url": "example.com/recordings/abc",
            "hs_call_status": "INVALID_STATUS" // Invalid status to trigger an error
        }
    };

    SimplePublicObject|error response = hubSpotClient->/[call_id].patch(payload);

    test:assertTrue(response is error, "Expected an error response for invalid update");
}

// Test: Archive a call
@test:Config {
    dependsOn: [testUpdateACall, testPostACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testArchiveACall() returns error? {
    string call_id = "";
    lock {
        call_id = hs_call_id;
    }

    http:Response response = check hubSpotClient->/[call_id].delete();

    test:assertEquals(response.statusCode, 204, "Call deletion failed");
}

// Test: Create a batch of calls
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchCreateCalls() returns error? {
    BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: [
            {
                properties: {
                    "hs_timestamp": "2025-02-17T01:32:44.872Z",
                    "hs_call_title": "Support call 1",
                    "hubspot_owner_id": hs_owner_id,
                    "hs_call_body": "Resolved issue 1",
                    "hs_call_duration": "3800",
                    "hs_call_from_number": "(857) 829 5489",
                    "hs_call_to_number": "(509) 999 9999",
                    "hs_call_recording_url": "example.com/recordings/abc1",
                    "hs_call_status": "COMPLETED"
                },
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: hs_association_type_id
                            }
                        ],
                        to: {
                            id: hs_object_id
                        }
                    }
                ]
            },
            {
                properties: {
                    "hs_timestamp": "2025-02-17T01:32:44.872Z",
                    "hs_call_title": "Support call 2",
                    "hubspot_owner_id": hs_owner_id,
                    "hs_call_body": "Resolved issue 2",
                    "hs_call_duration": "3800",
                    "hs_call_from_number": "(857) 829 5489",
                    "hs_call_to_number": "(509) 999 9999",
                    "hs_call_recording_url": "example.com/recordings/abc2",
                    "hs_call_status": "COMPLETED"
                },
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: hs_association_type_id
                            }
                        ],
                        to: {
                            id: hs_object_id
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

        hs_batch_call_ids = ids.cloneReadOnly();
    }
}

// Test: Read a batch of calls
@test:Config {
    dependsOn: [testBatchCreateCalls],
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchReadCalls() returns error? {
    string[] callIds;
    lock {
        callIds = hs_batch_call_ids.cloneReadOnly();
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

// Test: Update a batch of calls
@test:Config {
    dependsOn: [testBatchReadCalls],
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchUpdateCalls() returns error? {
    string[] callIds;
    lock {
        callIds = hs_batch_call_ids.cloneReadOnly();
    }

    BatchInputSimplePublicObjectBatchInput payload = {
        inputs: callIds.map(isolated function(string id) returns SimplePublicObjectBatchInput {
            return {
                id: id,
                properties: {
                    "hs_call_body": "Updated call body"
                }
            };
        })
    };

    BatchResponseSimplePublicObject response = check hubSpotClient->/batch/update.post(payload);

    test:assertTrue(response.results.length() == callIds.length(), "Batch update did not return expected number of results");

    foreach var result in response.results {
        test:assertTrue(result.properties["hs_call_body"] == "Updated call body", "Call body is not updated");
    }
}

// Test: Archive a batch of calls
@test:Config {
    dependsOn: [testBatchUpdateCalls],
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchArchiveCalls() returns error? {
    string[] callIds;
    lock {
        callIds = hs_batch_call_ids.cloneReadOnly();
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
