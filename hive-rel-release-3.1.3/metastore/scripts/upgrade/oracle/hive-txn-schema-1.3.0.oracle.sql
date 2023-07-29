-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the License); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an AS IS BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

--
-- Tables for transaction management
-- 

CREATE TABLE TXNS (
  TXN_ID NUMBER(19) PRIMARY KEY,
  TXN_STATE char(1) NOT NULL,
  TXN_STARTED NUMBER(19) NOT NULL,
  TXN_LAST_HEARTBEAT NUMBER(19) NOT NULL,
  TXN_USER varchar(128) NOT NULL,
  TXN_HOST varchar(128) NOT NULL,
  TXN_AGENT_INFO varchar2(128),
  TXN_META_INFO varchar2(128),
  TXN_HEARTBEAT_COUNT number(10)
) ROWDEPENDENCIES;

CREATE TABLE TXN_COMPONENTS (
  TC_TXNID NUMBER(19) REFERENCES TXNS (TXN_ID),
  TC_DATABASE VARCHAR2(128) NOT NULL,
  TC_TABLE VARCHAR2(128),
  TC_PARTITION VARCHAR2(767) NULL,
  TC_OPERATION_TYPE char(1) NOT NULL
) ROWDEPENDENCIES;

CREATE TABLE COMPLETED_TXN_COMPONENTS (
  CTC_TXNID NUMBER(19),
  CTC_DATABASE varchar(128) NOT NULL,
  CTC_TABLE varchar(128),
  CTC_PARTITION varchar(767)
) ROWDEPENDENCIES;

CREATE TABLE NEXT_TXN_ID (
  NTXN_NEXT NUMBER(19) NOT NULL
);
INSERT INTO NEXT_TXN_ID VALUES(1);

CREATE TABLE HIVE_LOCKS (
  HL_LOCK_EXT_ID NUMBER(19) NOT NULL,
  HL_LOCK_INT_ID NUMBER(19) NOT NULL,
  HL_TXNID NUMBER(19),
  HL_DB VARCHAR2(128) NOT NULL,
  HL_TABLE VARCHAR2(128),
  HL_PARTITION VARCHAR2(767),
  HL_LOCK_STATE CHAR(1) NOT NULL,
  HL_LOCK_TYPE CHAR(1) NOT NULL,
  HL_LAST_HEARTBEAT NUMBER(19) NOT NULL,
  HL_ACQUIRED_AT NUMBER(19),
  HL_USER varchar(128) NOT NULL,
  HL_HOST varchar(128) NOT NULL,
  HL_HEARTBEAT_COUNT number(10),
  HL_AGENT_INFO varchar2(128),
  HL_BLOCKEDBY_EXT_ID number(19),
  HL_BLOCKEDBY_INT_ID number(19),
  PRIMARY KEY(HL_LOCK_EXT_ID, HL_LOCK_INT_ID)
) ROWDEPENDENCIES;

CREATE INDEX HL_TXNID_INDEX ON HIVE_LOCKS (HL_TXNID);

CREATE TABLE NEXT_LOCK_ID (
  NL_NEXT NUMBER(19) NOT NULL
);
INSERT INTO NEXT_LOCK_ID VALUES(1);

CREATE TABLE COMPACTION_QUEUE (
  CQ_ID NUMBER(19) PRIMARY KEY,
  CQ_DATABASE varchar(128) NOT NULL,
  CQ_TABLE varchar(128) NOT NULL,
  CQ_PARTITION varchar(767),
  CQ_STATE char(1) NOT NULL,
  CQ_TYPE char(1) NOT NULL,
  CQ_TBLPROPERTIES varchar(2048),
  CQ_WORKER_ID varchar(128),
  CQ_START NUMBER(19),
  CQ_RUN_AS varchar(128),
  CQ_HIGHEST_TXN_ID NUMBER(19),
  CQ_META_INFO BLOB,
  CQ_HADOOP_JOB_ID varchar2(32)
) ROWDEPENDENCIES;

CREATE TABLE NEXT_COMPACTION_QUEUE_ID (
  NCQ_NEXT NUMBER(19) NOT NULL
);
INSERT INTO NEXT_COMPACTION_QUEUE_ID VALUES(1);

CREATE TABLE COMPLETED_COMPACTIONS (
  CC_ID NUMBER(19) PRIMARY KEY,
  CC_DATABASE varchar(128) NOT NULL,
  CC_TABLE varchar(128) NOT NULL,
  CC_PARTITION varchar(767),
  CC_STATE char(1) NOT NULL,
  CC_TYPE char(1) NOT NULL,
  CC_TBLPROPERTIES varchar(2048),
  CC_WORKER_ID varchar(128),
  CC_START NUMBER(19),
  CC_END NUMBER(19),
  CC_RUN_AS varchar(128),
  CC_HIGHEST_TXN_ID NUMBER(19),
  CC_META_INFO BLOB,
  CC_HADOOP_JOB_ID varchar2(32)
) ROWDEPENDENCIES;

CREATE TABLE AUX_TABLE (
  MT_KEY1 varchar2(128) NOT NULL,
  MT_KEY2 number(19) NOT NULL,
  MT_COMMENT varchar2(255),
  PRIMARY KEY(MT_KEY1, MT_KEY2)
);

CREATE TABLE WRITE_SET (
  WS_DATABASE varchar2(128) NOT NULL,
  WS_TABLE varchar2(128) NOT NULL,
  WS_PARTITION varchar2(767),
  WS_TXNID number(19) NOT NULL,
  WS_COMMIT_ID number(19) NOT NULL,
  WS_OPERATION_TYPE char(1) NOT NULL
);

