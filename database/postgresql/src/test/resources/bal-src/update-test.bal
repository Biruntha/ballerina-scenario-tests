// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

import ballerina/sql;
import ballerina/config;
import ballerinax/jdbc;

jdbc:Client testDB =  new jdbc:Client({
        url: config:getAsString("database.postgresql.test.jdbc.url"),
        username: config:getAsString("database.postgresql.test.jdbc.username"),
        password: config:getAsString("database.postgresql.test.jdbc.password")
    });

function testUpdateIntegerTypesWithValues() returns sql:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_INTEGER_TYPES", 1, 32765, 8388603, 2147483644);
}

function testUpdateIntegerTypesWithParams() returns sql:UpdateResult | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter smallIntVal = { sqlType: sql:TYPE_SMALLINT, value: 32765 };
    sql:Parameter intVal = { sqlType: sql:TYPE_INTEGER, value: 8388603 };
    sql:Parameter bigIntVal = { sqlType: sql:TYPE_BIGINT, value: 2147483644 };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_INTEGER_TYPES", id, smallIntVal, intVal, bigIntVal);
}

function testUpdateFixedPointTypesWithValues() returns sql:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 1, 1034.789, 15678.9845);
}

function testUpdateFixedPointTypesWithParams() returns sql:UpdateResult | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter numericVal = { sqlType: sql:TYPE_NUMERIC, value: 1034.789 };
    sql:Parameter decimalVal = { sqlType: sql:TYPE_DECIMAL, value: 15678.9845 };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", id, numericVal, decimalVal);
}

function testUpdateStringTypesWithValues() returns sql:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_STRING_TYPES", 1, "Varchar column", "Text column");
}

function testUpdateStringTypesWithParams() returns sql:UpdateResult | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter varcharVal = { sqlType: sql:TYPE_VARCHAR, value: "Varchar column" };
    sql:Parameter textVal = { sqlType: sql:TYPE_LONGVARCHAR, value: "Text column" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", id, varcharVal, textVal);
}

function testUpdateComplexTypesWithValues() returns sql:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_COMPLEX_TYPES", 1, "QmluYXJ5IENvbHVtbg==");
}

function testUpdateComplexTypesWithParams() returns sql:UpdateResult | error {
    sql:Parameter id =  { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter binaryVal =  { sqlType: sql:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", id, binaryVal);
}

function testUpdateDateTimeWithValues() returns sql:UpdateResult | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter dateVal = { sqlType: sql:TYPE_DATE, value: "2019-03-27-08:01" };
    sql:Parameter timeVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999" };
    sql:Parameter timezVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999+08:33" };
    sql:Parameter timestampVal = { sqlType: sql:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };
    sql:Parameter timestampzVal = { sqlType: sql:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_DATETIME_TYPES", id, dateVal, timeVal, timezVal, timestampVal,
        timestampzVal);
}

function testGeneratedKeyOnInsert() returns sql:UpdateResult | error {
    return testDB->update("INSERT INTO UPDATE_TEST_GENERATED_KEYS (COL1, COL2) VALUES ('abc', 92)");
}

function testGeneratedKeyOnInsertEmptyResults() returns sql:UpdateResult | error {
    return testDB->update("INSERT INTO UPDATE_TEST_GENERATED_KEYS_NO_KEY (COL1, COL2) VALUES ('xyz', 24)");
}

function runInsertQueryWithValues(string tableName, (int | float | string | byte[])... parameters)
             returns sql:UpdateResult | error {
    int paramLength = parameters.length();
    string paramString = "";
    if (paramLength >= 1) {
        paramString += "?";
    }
    if (paramLength > 1) {
        int i = 1;
        while (i < paramLength) {
            paramString += ", ?";
            i = i + 1;
        }
    }
    return testDB->update("INSERT INTO " + tableName + " VALUES(" + paramString + ")", ...parameters);
}


function runInsertQueryWithParams(string tableName, sql:Parameter... parameters)
             returns sql:UpdateResult | error {
    int paramLength = parameters.length();
    string paramString = "";
    if (paramLength >= 1) {
        paramString += "?";
    }
    if (paramLength > 1) {
        int i = 1;
        while (i < paramLength) {
            paramString += ", ?";
            i = i + 1;
        }
    }
    return testDB->update("INSERT INTO " + tableName + " VALUES(" + paramString + ")", ...parameters);
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}





