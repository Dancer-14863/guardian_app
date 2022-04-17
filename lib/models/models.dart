import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'models.g.dart';

const tableDistanceLog = SqfEntityTable(
  tableName: 'distanceLog',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  fields: [
    SqfEntityField('recordedDistance', DbType.integer),
    SqfEntityField(
      'recordedDate',
      DbType.datetime,
      defaultValue: 'DateTime.now()',
    ),
  ],
);

const tablePressurePlateLog = SqfEntityTable(
  tableName: 'pressurePlateLog',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  fields: [
    SqfEntityField('triggeredPressurePlate', DbType.integer),
    SqfEntityField(
      'recordedDate',
      DbType.datetime,
      defaultValue: 'DateTime.now()',
    ),
  ],
);

const tableConfiguration = SqfEntityTable(
  tableName: 'configuration',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  fields: [
    SqfEntityField('activateWaterGun', DbType.bool, defaultValue: false),
    SqfEntityField('distanceAlarmTrigger', DbType.integer, defaultValue: 20),
  ],
);

@SqfEntityBuilder(guardianDatabaseModel)
const guardianDatabaseModel = SqfEntityModel(
  modelName: 'GuardianDatabaseModel',
  databaseName: 'guardianDatabase.db',
  password: null,
  databaseTables: [tableDistanceLog, tablePressurePlateLog, tableConfiguration],
  dbVersion: 2,
);
