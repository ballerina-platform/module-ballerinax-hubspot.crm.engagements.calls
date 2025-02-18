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

service on new http:Listener(9090) {
    resource function post batch/read(BatchReadInputSimplePublicObjectId payload) returns BatchResponseSimplePublicObject{
        BatchResponseSimplePublicObject response = {
            status: "COMPLETE",
            startedAt: "2025-02-17T04:27:38.081Z",
            completedAt: "2025-02-17T04:27:38.101Z",
            results: [
                {
                    id: "76533404406",
                    properties: {
                        "property_date": "1572480000000",
                        "property_radio": "option_1",
                        "property_number": "17",
                        "property_string": "value",
                        "property_checkbox": "false",
                        "property_dropdown": "choice_b",
                        "property_multiple_checkboxes": "chocolate;strawberry"
                    },
                    propertiesWithHistory: {
                        "additionalProp1": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.720Z"
                            }
                        ],
                        "additionalProp2": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.720Z"
                            }
                        ],
                        "additionalProp3": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.720Z"
                            }
                        ]
                    },
                    createdAt: "2025-02-14T09:40:49.438Z",
                    updatedAt: "2025-02-14T09:40:49.785Z",
                    archived: false
                },
                {
                    "id": "76604609216",
                    "properties": {
                        "hs_call_title": "Support call",
                        "hs_createdate": "2025-02-14T09:37:01.763Z",
                        "hs_lastmodifieddate": "2025-02-14T09:37:02.094Z",
                        "hs_object_id": "76604609216"
                    },
                    "propertiesWithHistory": {
                        "hs_call_status": [
                            {
                                "value": "COMPLETED",
                                "timestamp": "2025-02-14T09:37:01.763Z",
                                "sourceType": "INTEGRATION",
                                "sourceId": "8111608"
                            }
                        ]
                    },
                    "createdAt": "2025-02-14T09:37:01.763Z",
                    "updatedAt": "2025-02-14T09:37:02.094Z",
                    "archived": false
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
                        "property_date": "1572480000000",
                        "property_radio": "option_1",
                        "property_number": "17",
                        "property_string": "value",
                        "property_checkbox": "false",
                        "property_dropdown": "choice_b",
                        "property_multiple_checkboxes": "chocolate;strawberry"
                    },
                    propertiesWithHistory: {
                        "additionalProp1": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.720Z"
                            }
                        ],
                        "additionalProp2": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.720Z"
                            }
                        ],
                        "additionalProp3": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.720Z"
                            }
                        ]
                    },
                    createdAt: "2025-02-14T09:40:49.438Z",
                    updatedAt: "2025-02-14T09:40:49.785Z",
                    archived: false
                },
                {
                    "id": "76604609216",
                    "properties": {
                        "hs_call_title": "Support call",
                        "hs_createdate": "2025-02-14T09:37:01.763Z",
                        "hs_lastmodifieddate": "2025-02-14T09:37:02.094Z",
                        "hs_object_id": "76604609216"
                    },
                    "propertiesWithHistory": {
                        "hs_call_status": [
                            {
                                "value": "COMPLETED",
                                "timestamp": "2025-02-14T09:37:01.763Z",
                                "sourceType": "INTEGRATION",
                                "sourceId": "8111608"
                            }
                        ]
                    },
                    "createdAt": "2025-02-14T09:37:01.763Z",
                    "updatedAt": "2025-02-14T09:37:02.094Z",
                    "archived": false
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
                    properties: {
                        "property_date": "1572480000000",
                        "property_radio": "option_1",
                        "property_number": "17",
                        "property_string": "value",
                        "property_checkbox": "false",
                        "property_dropdown": "choice_b",
                        "property_multiple_checkboxes": "chocolate;strawberry"
                    },
                    propertiesWithHistory: {
                            "additionalProp1": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.733Z"
                            }
                        ],
                        "additionalProp2": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.733Z"
                            }
                        ],
                        "additionalProp3": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.733Z"
                            }
                        ]
                    },
                    createdAt: "2025-02-14T09:40:49.438Z",
                    updatedAt: "2025-02-14T09:40:49.785Z",
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
                    "createdAt": "2025-02-17T04:04:47.711Z",
                    "archived": true,
                    "archivedAt": "2025-02-17T04:04:47.711Z",
                    "new": true,
                    "propertiesWithHistory": {
                        "additionalProp1": [
                        {
                            "sourceId": "string",
                            "sourceType": "string",
                            "sourceLabel": "string",
                            "updatedByUserId": 0,
                            "value": "string",
                            "timestamp": "2025-02-17T04:04:47.711Z"
                        }
                        ],
                        "additionalProp2": [
                        {
                            "sourceId": "string",
                            "sourceType": "string",
                            "sourceLabel": "string",
                            "updatedByUserId": 0,
                            "value": "string",
                            "timestamp": "2025-02-17T04:04:47.711Z"
                        }
                        ],
                        "additionalProp3": [
                        {
                            "sourceId": "string",
                            "sourceType": "string",
                            "sourceLabel": "string",
                            "updatedByUserId": 0,
                            "value": "string",
                            "timestamp": "2025-02-17T04:04:47.711Z"
                        }
                        ]
                    },
                    "id": "string",
                    "properties": {
                        "additionalProp1": "string",
                        "additionalProp2": "string",
                        "additionalProp3": "string"
                    },
                    "updatedAt": "2025-02-17T04:04:47.711Z"
                }
            ]
        };
        return response;
    }

    resource function get [string callId](http:Request req) returns SimplePublicObjectWithAssociations {
        SimplePublicObjectWithAssociations response = {
            id: callId,
            properties: {
                "hs_call_title": "Support call",
                "hs_createdate": "2025-02-14T09:37:01.763Z",
                "hs_lastmodifieddate": "2025-02-14T09:37:02.094Z",
                "hs_object_id": callId
            },
            propertiesWithHistory: {
                "hs_call_status": [
                    {
                        "value": "COMPLETED",
                        "timestamp": "2025-02-14T09:37:01.763Z",
                        "sourceType": "INTEGRATION",
                        "sourceId": "8111608"
                    }
                ]
            },
            createdAt: "2025-02-14T09:37:01.763Z",
            updatedAt: "2025-02-14T09:37:02.094Z",
            archived: false
        };
        return response;
    }

    resource function delete [string callId](http:Request req) returns http:Response {
        http:Response response = new;
        response.statusCode = http:STATUS_NO_CONTENT;
        return response;
    }

    resource function patch [string callId](SimplePublicObjectInput payload) returns SimplePublicObject {
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
                        "property_date": "1572480000000",
                        "property_radio": "option_1",
                        "property_number": "17",
                        "property_string": "value",
                        "property_checkbox": "false",
                        "property_dropdown": "choice_b",
                        "property_multiple_checkboxes": "chocolate;strawberry"
                    },
                    propertiesWithHistory: {
                        "additionalProp1": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.720Z"
                            }
                        ]
                    },
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

    resource function post .(SimplePublicObjectInputForCreate payload) returns SimplePublicObject {
        SimplePublicObject response = {
            id: "new_call_id",
            properties: payload.properties,
            createdAt: "2025-02-14T09:37:01.763Z",
            updatedAt: "2025-02-14T09:37:02.094Z",
            archived: false
        };
        return response;
    }

    resource function post search(PublicObjectSearchRequest payload) returns CollectionResponseWithTotalSimplePublicObjectForwardPaging {
        CollectionResponseWithTotalSimplePublicObjectForwardPaging response = {
            results: [
                {
                    id: "76533404406",
                    properties: {
                        "property_date": "1572480000000",
                        "property_radio": "option_1",
                        "property_number": "17",
                        "property_string": "value",
                        "property_checkbox": "false",
                        "property_dropdown": "choice_b",
                        "property_multiple_checkboxes": "chocolate;strawberry"
                    },
                    propertiesWithHistory: {
                        "additionalProp1": [
                            {
                                "sourceId": "string",
                                "sourceType": "string",
                                "sourceLabel": "string",
                                "updatedByUserId": 0,
                                "value": "string",
                                "timestamp": "2025-02-17T04:04:47.720Z"
                            }
                        ]
                    },
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
