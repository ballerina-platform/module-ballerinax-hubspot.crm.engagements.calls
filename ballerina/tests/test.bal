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

import ballerina/oauth2;
import ballerina/os;
import ballerina/test;
import ballerina/http;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/objects/calls" : "http://localhost:9090";

final string clientId = os:getEnv("HUBSPOT_CLIENT_ID");
final string clientSecret = os:getEnv("HUBSPOT_CLIENT_SECRET");
final string refreshToken = os:getEnv("HUBSPOT_REFRESH_TOKEN");

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

final string hs_owner_id = "77367788";
isolated string hs_call_id = "";

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testPostACall() returns error? {
    SimplePublicObjectInputForCreate payload = {
        "properties": {
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
        "associations": [
        {
            "types": [
                {
                    "associationCategory": "HUBSPOT_DEFINED",
                    "associationTypeId": 194
                    }
                ],
                "to": {
                    "id": "83829237490"
                }
            }
        ]
    };

    SimplePublicObject|error response = hubSpotClient->/.post(payload);
    test:assertTrue(response is SimplePublicObject, "Response is not a SimplePublicObject");

    if response is SimplePublicObject {
        lock {
	        hs_call_id = response.id;
        }
    }
}

@test:Config {
    dependsOn: [testPostACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetACall() returns error? {
    var response = hubSpotClient->/.get();

    if response is CollectionResponseSimplePublicObjectWithAssociationsForwardPaging {
        test:assertTrue(response.results.length() > 0, "No calls found");
    } else {
        test:assertTrue(false, "Response is not in correct type");
    }
}

@test:Config {
    dependsOn: [testPostACall],
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetACallById() returns error? {
    string call_id = "";
    lock {
        call_id = hs_call_id;
    }
    
    if call_id == "" {
        test:assertTrue(false, "Call id is empty");
    }
    
    var response = hubSpotClient->/[call_id].get();

    if response is SimplePublicObject {
        test:assertTrue(response.id == call_id, "Call id mismatch");
    } else {
        test:assertTrue(false, "Response is not in correct type");
    }
}

@test:Config {
    dependsOn: [testPostACall, testGetACallById],
    groups: ["live_tests", "mock_tests"]
}
isolated  function testArchiveACall() returns error? {
    string call_id = "";
    lock {
        call_id = hs_call_id;
    }
    
    if call_id == "" {
        test:assertTrue(false, "Call id is empty");
    }
    
    http:Response|error response = hubSpotClient->/[call_id].delete();
    
    if response is http:Response {
        test:assertTrue(response.statusCode == 204, "Call deletion failed");
    } else {
        test:assertTrue(false, "Response is not in correct type");
    }
}

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
                "associations": [
                {
                    "types": [
                        {
                            "associationCategory": "HUBSPOT_DEFINED",
                            "associationTypeId": 194
                            }
                        ],
                        "to": {
                            "id": "84082396899"
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
                "associations": [
                {
                    "types": [
                        {
                            "associationCategory": "HUBSPOT_DEFINED",
                            "associationTypeId": 194
                            }
                        ],
                        "to": {
                            "id": "84059587267"
                        }
                    }
                ]
            }
        ]
    };

    BatchResponseSimplePublicObject|error response = hubSpotClient->/batch/create.post(payload);
    test:assertTrue(response is BatchResponseSimplePublicObject, "Response is not a BatchResponseSimplePublicObject");

    if response is BatchResponseSimplePublicObject {
        test:assertTrue(response.results.length() == 2, "Batch create did not return expected number of results");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchReadCalls() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        inputs: [
            { "id": "75868168947" },
            { "id": "76533404406" },
            { "id": "76604609216" }
        ],
        properties: [
            "hs_createdate",
            "hs_call_title"
        ],
        propertiesWithHistory: [
            "hs_call_status"
        ]
    };

    BatchResponseSimplePublicObject|error response = hubSpotClient->/batch/read.post(payload);
    test:assertTrue(response is BatchResponseSimplePublicObject, "Response is not a BatchResponseSimplePublicObject");

    if response is BatchResponseSimplePublicObject {
        test:assertTrue(response.results.length() == 2, "Batch read did not return expected number of results");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchArchiveCalls() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        inputs: [
            { "id": "75868168947" },
            { "id": "76533404406" },
            { "id": "76604609216" }
        ],
        properties: [
            "hs_createdate",
            "hs_call_title"
        ],
        propertiesWithHistory: [
            "hs_call_status"
        ]
    };

    http:Response|error response = hubSpotClient->/batch/archive.post(payload);
    test:assertTrue(response is http:Response, "Response is not an http:Response");

    if response is http:Response {
        test:assertTrue(response.statusCode == 204, "Batch archive failed");
    }
}