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

isolated string[] callIds = [];

service on new http:Listener(9090) {
    resource function post batch/read(BatchReadInputSimplePublicObjectId payload) returns BatchResponseSimplePublicObject {
        BatchResponseSimplePublicObject response = {
            status: "COMPLETE",
            startedAt: "2025-02-17T04:27:38.081Z",
            completedAt: "2025-02-17T04:27:38.101Z",
            results: [
                {
                    id: "76533404406",
                    properties: {
                        "hs_timestamp": "2025-02-17T01:32:44.872Z",
                        "hs_call_title": "Support call",
                        "hubspot_owner_id": hsOwnerId,
                        "hs_call_body": "Resolved issue",
                        "hs_call_duration": "3800",
                        "hs_call_from_number": "(857) 829 5489",
                        "hs_call_to_number": "(509) 999 9999",
                        "hs_call_recording_url": "example.com/recordings/abc",
                        "hs_call_status": "COMPLETED"
                    },
                    propertiesWithHistory: {},
                    createdAt: "2025-02-14T09:40:49.438Z",
                    updatedAt: "2025-02-14T09:40:49.785Z",
                    archived: false
                },
                {
                    id: "76604609216",
                    properties: {
                        "hs_timestamp": "2025-02-17T01:32:44.872Z",
                        "hs_call_title": "Support call",
                        "hubspot_owner_id": hsOwnerId,
                        "hs_call_body": "Resolved issue",
                        "hs_call_duration": "3800",
                        "hs_call_from_number": "(857) 829 5489",
                        "hs_call_to_number": "(509) 999 9999",
                        "hs_call_recording_url": "example.com/recordings/abc",
                        "hs_call_status": "COMPLETED"
                    },
                    propertiesWithHistory: {},
                    createdAt: "2025-02-14T09:37:01.763Z",
                    updatedAt: "2025-02-14T09:37:02.094Z",
                    archived: false
                }
            ]
        };
        return response;
    }

    resource function post batch/create(BatchInputSimplePublicObjectInputForCreate payload) returns BatchResponseSimplePublicObject {
        BatchResponseSimplePublicObject response = {
            status: "COMPLETE",
            startedAt: "2025-02-17T04:27:38.081Z",
            completedAt: "2025-02-17T04:27:38.101Z",
            results: [
                {
                    id: "76533404406",
                    properties: {
                        "hs_timestamp": "2025-02-17T01:32:44.872Z",
                        "hs_call_title": "Support call",
                        "hubspot_owner_id": hsOwnerId,
                        "hs_call_body": "Resolved issue",
                        "hs_call_duration": "3800",
                        "hs_call_from_number": "(857) 829 5489",
                        "hs_call_to_number": "(509) 999 9999",
                        "hs_call_recording_url": "example.com/recordings/abc",
                        "hs_call_status": "COMPLETED"
                    },
                    propertiesWithHistory: {},
                    createdAt: "2025-02-14T09:40:49.438Z",
                    updatedAt: "2025-02-14T09:40:49.785Z",
                    archived: false
                },
                {
                    id: "76604609216",
                    properties: {
                        "hs_timestamp": "2025-02-17T01:32:44.872Z",
                        "hs_call_title": "Support call",
                        "hubspot_owner_id": hsOwnerId,
                        "hs_call_body": "Resolved issue",
                        "hs_call_duration": "3800",
                        "hs_call_from_number": "(857) 829 5489",
                        "hs_call_to_number": "(509) 999 9999",
                        "hs_call_recording_url": "example.com/recordings/abc",
                        "hs_call_status": "COMPLETED"
                    },
                    propertiesWithHistory: {},
                    createdAt: "2025-02-14T09:37:01.763Z",
                    updatedAt: "2025-02-14T09:37:02.094Z",
                    archived: false
                }
            ]
        };
        return response;
    }

    resource function post batch/archive(@http:Payload json payload) returns http:Response|error {
        http:Response response = new;
        if payload.inputs is json[] && payload.inputs != null {
            response.statusCode = http:STATUS_NO_CONTENT;
        } else {
            response.statusCode = http:STATUS_BAD_REQUEST;
        }
        return response;
    }

    resource function post batch/update(BatchInputSimplePublicObjectBatchInput payload) returns BatchResponseSimplePublicObject {
        BatchResponseSimplePublicObject response = {
            status: "COMPLETE",
            startedAt: "2025-02-17T04:27:38.081Z",
            completedAt: "2025-02-17T04:27:38.101Z",
            results: [
                {
                    id: "76533404406",
                    properties: payload.inputs[0].properties,
                    propertiesWithHistory: {},
                    createdAt: "2025-02-14T09:40:49.438Z",
                    updatedAt: "2025-02-14T09:40:49.785Z",
                    archived: false
                },
                {
                    id: "76604609216",
                    properties: payload.inputs[1].properties,
                    propertiesWithHistory: {},
                    createdAt: "2025-02-14T09:37:01.763Z",
                    updatedAt: "2025-02-14T09:37:02.094Z",
                    archived: false
                }
            ]
        };
        return response;
    }

    resource function post batch/upsert(BatchInputSimplePublicObjectBatchInputUpsert payload) returns BatchResponseSimplePublicUpsertObject {
        BatchResponseSimplePublicUpsertObject response = {
            status: "COMPLETE",
            startedAt: "2025-02-17T04:27:38.081Z",
            completedAt: "2025-02-17T04:27:38.101Z",
            results: [
                {
                    createdAt: "2025-02-17T04:04:47.711Z",
                    archived: true,
                    archivedAt: "2025-02-17T04:04:47.711Z",
                    'new: true,
                    propertiesWithHistory: {},
                    id: "string",
                    properties: {
                        "hs_timestamp": "2025-02-17T01:32:44.872Z",
                        "hs_call_title": "Support call",
                        "hubspot_owner_id": hsOwnerId,
                        "hs_call_body": "Resolved issue",
                        "hs_call_duration": "3800",
                        "hs_call_from_number": "(857) 829 5489",
                        "hs_call_to_number": "(509) 999 9999",
                        "hs_call_recording_url": "example.com/recordings/abc",
                        "hs_call_status": "COMPLETED"
                    },
                    updatedAt: "2025-02-17T04:04:47.711Z"
                }
            ]
        };
        return response;
    }

    resource function get [string callId](http:Request req) returns SimplePublicObjectWithAssociations|error {
        string id = "";
        lock {
            // find the id from the callIds array  
            foreach string i in callIds {
                if i == callId {
                    id = i;
                    break;
                }
            }
        }
        if id == "" {
            return error("Call ID not found");
        }

        SimplePublicObjectWithAssociations response = {
            id: callId,
            properties: {
                "hs_call_title": "Support call",
                "hs_createdate": "2025-02-14T09:37:01.763Z",
                "hs_lastmodifieddate": "2025-02-14T09:37:02.094Z",
                "hs_object_id": callId
            },
            propertiesWithHistory: {},
            createdAt: "2025-02-14T09:37:01.763Z",
            updatedAt: "2025-02-14T09:37:02.094Z",
            archived: false
        };
        return response;
    }

    resource function delete [string callId](http:Request req) returns http:Response {
        string id = "";

        http:Response response = new;
        lock {
            // find the id from the callIds array
            int index = 0;
            foreach string i in callIds {
                if i == callId {
                    id = i;
                    response.statusCode = 204;
                    // remove the id from the callIds array
                    _ = callIds.remove(index);
                    break;
                }
                index += 1;
            }
        }

        if id == "0" {
            response.statusCode = 404;
        }

        return response;
    }

    resource function patch [string callId](SimplePublicObjectInput payload) returns SimplePublicObject|error {
        string id = "";
        lock {
            // find the id from the callIds array
            foreach string i in callIds {
                if i == callId {
                    id = i;
                    break;
                }
            }
        }

        if id == "" {
            return error("Call ID not found");
        }

        // validate the hs_call_status
        if payload.properties["hs_call_status"] != "COMPLETED" {
            return error("Invalid hs_call_status");
        }

        SimplePublicObject response = {
            id: callId,
            properties: payload.properties,
            createdAt: "2025-02-14T09:37:01.763Z",
            updatedAt: "2025-02-14T09:37:02.094Z",
            archived: false
        };
        return response;
    }

    resource function get .(http:Request req) returns CollectionResponseSimplePublicObjectWithAssociationsForwardPaging {
        CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = {
            results: [
                {
                    id: "76533404406",
                    properties: {
                        "hs_timestamp": "2025-02-17T01:32:44.872Z",
                        "hs_call_title": "Support call",
                        "hubspot_owner_id": hsOwnerId,
                        "hs_call_body": "Resolved issue",
                        "hs_call_duration": "3800",
                        "hs_call_from_number": "(857) 829 5489",
                        "hs_call_to_number": "(509) 999 9999",
                        "hs_call_recording_url": "example.com/recordings/abc",
                        "hs_call_status": "COMPLETED"
                    },
                    propertiesWithHistory: {},
                    createdAt: "2025-02-14T09:40:49.438Z",
                    updatedAt: "2025-02-14T09:40:49.785Z",
                    archived: false
                }
            ],
            paging: {
                next: {
                    after: "NTI1Cg%3D%3D",
                    link: "?after=NTI1Cg%3D%3D"
                }
            }
        };
        return response;
    }

    resource function post .(SimplePublicObjectInputForCreate payload) returns SimplePublicObject|http:Response|error {
        string callId = (getMaximumCallId() + 1).toString();

        // valid association types
        foreach PublicAssociationsForObject item in payload.associations {
            foreach AssociationSpec ass_type in item.types {
                var x = ass_type.associationTypeId;

                if x !is 194 && x !is 182 {
                    http:Response response = new;
                    response.statusCode = 400;
                    return response;
                }
            }
        }

        SimplePublicObject response = {
            id: callId.toString(),
            properties: payload.properties,
            createdAt: "2025-02-14T09:37:01.763Z",
            updatedAt: "2025-02-14T09:37:02.094Z",
            archived: false
        };
        lock {
            callIds.push(callId);
        }
        return response;
    }

    resource function post search(PublicObjectSearchRequest payload) returns CollectionResponseWithTotalSimplePublicObjectForwardPaging {
        CollectionResponseWithTotalSimplePublicObjectForwardPaging response = {
            results: [
                {
                    id: "76533404406",
                    properties: {
                        "hs_timestamp": "2025-02-17T01:32:44.872Z",
                        "hs_call_title": "Support call",
                        "hubspot_owner_id": hsOwnerId,
                        "hs_call_body": "Resolved issue",
                        "hs_call_duration": "3800",
                        "hs_call_from_number": "(857) 829 5489",
                        "hs_call_to_number": "(509) 999 9999",
                        "hs_call_recording_url": "example.com/recordings/abc",
                        "hs_call_status": "COMPLETED"
                    },
                    propertiesWithHistory: {},
                    createdAt: "2025-02-14T09:40:49.438Z",
                    updatedAt: "2025-02-14T09:40:49.785Z",
                    archived: false
                }
            ],
            total: 1,
            paging: {
                next: {
                    after: "NTI1Cg%3D%3D",
                    link: "?after=NTI1Cg%3D%3D"
                }
            }
        };
        return response;
    }
}

function getMaximumCallId() returns int {
    int max = 0;
    lock {
        foreach string id in callIds {
            int intId = checkpanic int:fromString(id);
            if intId > max {
                max = intId;
            }
        }
    }
    return max;
}
