// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/seeding.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import 'seeding.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'seeding.pbenum.dart';

class ShippingAddress extends $pb.GeneratedMessage {
  factory ShippingAddress({
    $core.String? name,
    $core.String? phone,
    $core.String? addressLine1,
    $core.String? addressLine2,
    $core.String? city,
    $core.String? postalCode,
    $core.String? country,
  }) {
    final result = ShippingAddress._();
    if (name != null) result.name = name;
    if (phone != null) result.phone = phone;
    if (addressLine1 != null) result.addressLine1 = addressLine1;
    if (addressLine2 != null) result.addressLine2 = addressLine2;
    if (city != null) result.city = city;
    if (postalCode != null) result.postalCode = postalCode;
    if (country != null) result.country = country;
    return result;
  }

  ShippingAddress._();

  factory ShippingAddress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShippingAddress()..mergeFromBuffer(data, registry);
  factory ShippingAddress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShippingAddress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShippingAddress',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ShippingAddress.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'phone')
    ..aOS(3, _omitFieldNames ? '' : 'addressLine1', protoName: 'address_line_1')
    ..aOS(4, _omitFieldNames ? '' : 'addressLine2', protoName: 'address_line_2')
    ..aOS(5, _omitFieldNames ? '' : 'city')
    ..aOS(6, _omitFieldNames ? '' : 'postalCode')
    ..aOS(7, _omitFieldNames ? '' : 'country')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShippingAddress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShippingAddress copyWith(void Function(ShippingAddress) updates) =>
      super.copyWith((message) => updates(message as ShippingAddress))
          as ShippingAddress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ShippingAddress() / ShippingAddress.new instead')
  static ShippingAddress create() => ShippingAddress._();
  static $pb.GeneratedMessage $_createMessage() => ShippingAddress._();
  @$core.override
  ShippingAddress createEmptyInstance() => ShippingAddress._();
  @$core.pragma('dart2js:noInline')
  static ShippingAddress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShippingAddress>(
          ShippingAddress.$_createMessage);
  static ShippingAddress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phone => $_getSZ(1);
  @$pb.TagNumber(2)
  set phone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhone() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhone() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get addressLine1 => $_getSZ(2);
  @$pb.TagNumber(3)
  set addressLine1($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAddressLine1() => $_has(2);
  @$pb.TagNumber(3)
  void clearAddressLine1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get addressLine2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set addressLine2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddressLine2() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddressLine2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get city => $_getSZ(4);
  @$pb.TagNumber(5)
  set city($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCity() => $_has(4);
  @$pb.TagNumber(5)
  void clearCity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get postalCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set postalCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPostalCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearPostalCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get country => $_getSZ(6);
  @$pb.TagNumber(7)
  set country($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCountry() => $_has(6);
  @$pb.TagNumber(7)
  void clearCountry() => $_clearField(7);
}

class SampleOutcome extends $pb.GeneratedMessage {
  factory SampleOutcome({
    $core.String? contentUrl,
    $core.String? contentType,
    $core.String? publishItemId,
    $fixnum.Int64? impressions,
    $fixnum.Int64? views,
    $fixnum.Int64? engagements,
    $fixnum.Int64? conversionsCount,
    $core.String? attributableRevenue,
    $core.String? currency,
    SeedingSourceClass? sourceClass,
    SeedingConfidenceLevel? confidenceLevel,
    $core.String? confidenceReason,
    $core.String? notes,
    $1.Timestamp? loggedAt,
  }) {
    final result = SampleOutcome._();
    if (contentUrl != null) result.contentUrl = contentUrl;
    if (contentType != null) result.contentType = contentType;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (impressions != null) result.impressions = impressions;
    if (views != null) result.views = views;
    if (engagements != null) result.engagements = engagements;
    if (conversionsCount != null) result.conversionsCount = conversionsCount;
    if (attributableRevenue != null)
      result.attributableRevenue = attributableRevenue;
    if (currency != null) result.currency = currency;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (confidenceLevel != null) result.confidenceLevel = confidenceLevel;
    if (confidenceReason != null) result.confidenceReason = confidenceReason;
    if (notes != null) result.notes = notes;
    if (loggedAt != null) result.loggedAt = loggedAt;
    return result;
  }

  SampleOutcome._();

  factory SampleOutcome.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleOutcome()..mergeFromBuffer(data, registry);
  factory SampleOutcome.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleOutcome()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleOutcome',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleOutcome.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'contentUrl')
    ..aOS(2, _omitFieldNames ? '' : 'contentType')
    ..aOS(3, _omitFieldNames ? '' : 'publishItemId')
    ..aInt64(4, _omitFieldNames ? '' : 'impressions')
    ..aInt64(5, _omitFieldNames ? '' : 'views')
    ..aInt64(6, _omitFieldNames ? '' : 'engagements')
    ..aInt64(7, _omitFieldNames ? '' : 'conversionsCount')
    ..aOS(8, _omitFieldNames ? '' : 'attributableRevenue')
    ..aOS(9, _omitFieldNames ? '' : 'currency')
    ..aE<SeedingSourceClass>(10, _omitFieldNames ? '' : 'sourceClass',
        enumValues: SeedingSourceClass.values)
    ..aE<SeedingConfidenceLevel>(11, _omitFieldNames ? '' : 'confidenceLevel',
        enumValues: SeedingConfidenceLevel.values)
    ..aOS(12, _omitFieldNames ? '' : 'confidenceReason')
    ..aOS(13, _omitFieldNames ? '' : 'notes')
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'loggedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleOutcome clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleOutcome copyWith(void Function(SampleOutcome) updates) =>
      super.copyWith((message) => updates(message as SampleOutcome))
          as SampleOutcome;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SampleOutcome() / SampleOutcome.new instead')
  static SampleOutcome create() => SampleOutcome._();
  static $pb.GeneratedMessage $_createMessage() => SampleOutcome._();
  @$core.override
  SampleOutcome createEmptyInstance() => SampleOutcome._();
  @$core.pragma('dart2js:noInline')
  static SampleOutcome getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SampleOutcome>(
          SampleOutcome.$_createMessage);
  static SampleOutcome? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get contentUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set contentUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContentUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearContentUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentType => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContentType() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get publishItemId => $_getSZ(2);
  @$pb.TagNumber(3)
  set publishItemId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublishItemId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublishItemId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get impressions => $_getI64(3);
  @$pb.TagNumber(4)
  set impressions($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImpressions() => $_has(3);
  @$pb.TagNumber(4)
  void clearImpressions() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get views => $_getI64(4);
  @$pb.TagNumber(5)
  set views($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasViews() => $_has(4);
  @$pb.TagNumber(5)
  void clearViews() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get engagements => $_getI64(5);
  @$pb.TagNumber(6)
  set engagements($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEngagements() => $_has(5);
  @$pb.TagNumber(6)
  void clearEngagements() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get conversionsCount => $_getI64(6);
  @$pb.TagNumber(7)
  set conversionsCount($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConversionsCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearConversionsCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get attributableRevenue => $_getSZ(7);
  @$pb.TagNumber(8)
  set attributableRevenue($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAttributableRevenue() => $_has(7);
  @$pb.TagNumber(8)
  void clearAttributableRevenue() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get currency => $_getSZ(8);
  @$pb.TagNumber(9)
  set currency($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCurrency() => $_has(8);
  @$pb.TagNumber(9)
  void clearCurrency() => $_clearField(9);

  @$pb.TagNumber(10)
  SeedingSourceClass get sourceClass => $_getN(9);
  @$pb.TagNumber(10)
  set sourceClass(SeedingSourceClass value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSourceClass() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceClass() => $_clearField(10);

  @$pb.TagNumber(11)
  SeedingConfidenceLevel get confidenceLevel => $_getN(10);
  @$pb.TagNumber(11)
  set confidenceLevel(SeedingConfidenceLevel value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasConfidenceLevel() => $_has(10);
  @$pb.TagNumber(11)
  void clearConfidenceLevel() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get confidenceReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set confidenceReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasConfidenceReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearConfidenceReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get notes => $_getSZ(12);
  @$pb.TagNumber(13)
  set notes($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNotes() => $_has(12);
  @$pb.TagNumber(13)
  void clearNotes() => $_clearField(13);

  @$pb.TagNumber(14)
  $1.Timestamp get loggedAt => $_getN(13);
  @$pb.TagNumber(14)
  set loggedAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasLoggedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearLoggedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureLoggedAt() => $_ensure(13);
}

class SampleShipment extends $pb.GeneratedMessage {
  factory SampleShipment({
    $core.String? shipmentId,
    $core.String? requestId,
    $core.String? workspaceId,
    $core.String? trackingNumber,
    $core.String? carrier,
    $core.String? shippingCost,
    $1.Timestamp? shippedAt,
    $1.Timestamp? deliveredAt,
    SampleShipmentStatus? status,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = SampleShipment._();
    if (shipmentId != null) result.shipmentId = shipmentId;
    if (requestId != null) result.requestId = requestId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (trackingNumber != null) result.trackingNumber = trackingNumber;
    if (carrier != null) result.carrier = carrier;
    if (shippingCost != null) result.shippingCost = shippingCost;
    if (shippedAt != null) result.shippedAt = shippedAt;
    if (deliveredAt != null) result.deliveredAt = deliveredAt;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  SampleShipment._();

  factory SampleShipment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleShipment()..mergeFromBuffer(data, registry);
  factory SampleShipment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleShipment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleShipment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleShipment.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'shipmentId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'trackingNumber')
    ..aOS(5, _omitFieldNames ? '' : 'carrier')
    ..aOS(6, _omitFieldNames ? '' : 'shippingCost')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'shippedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'deliveredAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aE<SampleShipmentStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: SampleShipmentStatus.values)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleShipment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleShipment copyWith(void Function(SampleShipment) updates) =>
      super.copyWith((message) => updates(message as SampleShipment))
          as SampleShipment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SampleShipment() / SampleShipment.new instead')
  static SampleShipment create() => SampleShipment._();
  static $pb.GeneratedMessage $_createMessage() => SampleShipment._();
  @$core.override
  SampleShipment createEmptyInstance() => SampleShipment._();
  @$core.pragma('dart2js:noInline')
  static SampleShipment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SampleShipment>(
          SampleShipment.$_createMessage);
  static SampleShipment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shipmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set shipmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShipmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShipmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get trackingNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set trackingNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTrackingNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrackingNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get carrier => $_getSZ(4);
  @$pb.TagNumber(5)
  set carrier($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCarrier() => $_has(4);
  @$pb.TagNumber(5)
  void clearCarrier() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get shippingCost => $_getSZ(5);
  @$pb.TagNumber(6)
  set shippingCost($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShippingCost() => $_has(5);
  @$pb.TagNumber(6)
  void clearShippingCost() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get shippedAt => $_getN(6);
  @$pb.TagNumber(7)
  set shippedAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasShippedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearShippedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureShippedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Timestamp get deliveredAt => $_getN(7);
  @$pb.TagNumber(8)
  set deliveredAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDeliveredAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeliveredAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureDeliveredAt() => $_ensure(7);

  @$pb.TagNumber(9)
  SampleShipmentStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(SampleShipmentStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureUpdatedAt() => $_ensure(10);
}

class SampleRequest extends $pb.GeneratedMessage {
  factory SampleRequest({
    $core.String? requestId,
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? productId,
    $core.String? creatorEntityId,
    SampleRequestStatus? status,
    $core.int? quantity,
    SampleOutcomeStatus? outcomeStatus,
    SampleOutcome? outcome,
    FollowUpStatus? followUpStatus,
    ShippingAddress? shippingAddress,
    $core.String? contentRequirements,
    $core.String? deadline,
    $core.String? declineReason,
    $core.String? notes,
    $core.String? productTitle,
    $core.String? productCogs,
    $core.String? creatorName,
    $core.String? creatorHandle,
    $core.String? creatorAvatarUrl,
    $fixnum.Int64? creatorFollowers,
    $core.String? creatorPlatform,
    SampleShipment? shipment,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = SampleRequest._();
    if (requestId != null) result.requestId = requestId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (productId != null) result.productId = productId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (status != null) result.status = status;
    if (quantity != null) result.quantity = quantity;
    if (outcomeStatus != null) result.outcomeStatus = outcomeStatus;
    if (outcome != null) result.outcome = outcome;
    if (followUpStatus != null) result.followUpStatus = followUpStatus;
    if (shippingAddress != null) result.shippingAddress = shippingAddress;
    if (contentRequirements != null)
      result.contentRequirements = contentRequirements;
    if (deadline != null) result.deadline = deadline;
    if (declineReason != null) result.declineReason = declineReason;
    if (notes != null) result.notes = notes;
    if (productTitle != null) result.productTitle = productTitle;
    if (productCogs != null) result.productCogs = productCogs;
    if (creatorName != null) result.creatorName = creatorName;
    if (creatorHandle != null) result.creatorHandle = creatorHandle;
    if (creatorAvatarUrl != null) result.creatorAvatarUrl = creatorAvatarUrl;
    if (creatorFollowers != null) result.creatorFollowers = creatorFollowers;
    if (creatorPlatform != null) result.creatorPlatform = creatorPlatform;
    if (shipment != null) result.shipment = shipment;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  SampleRequest._();

  factory SampleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleRequest()..mergeFromBuffer(data, registry);
  factory SampleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'campaignId')
    ..aOS(4, _omitFieldNames ? '' : 'productId')
    ..aOS(5, _omitFieldNames ? '' : 'creatorEntityId')
    ..aE<SampleRequestStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: SampleRequestStatus.values)
    ..aI(7, _omitFieldNames ? '' : 'quantity')
    ..aE<SampleOutcomeStatus>(8, _omitFieldNames ? '' : 'outcomeStatus',
        enumValues: SampleOutcomeStatus.values)
    ..aOM<SampleOutcome>(9, _omitFieldNames ? '' : 'outcome',
        subBuilder: SampleOutcome.$_createMessage)
    ..aE<FollowUpStatus>(10, _omitFieldNames ? '' : 'followUpStatus',
        enumValues: FollowUpStatus.values)
    ..aOM<ShippingAddress>(11, _omitFieldNames ? '' : 'shippingAddress',
        subBuilder: ShippingAddress.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'contentRequirements')
    ..aOS(13, _omitFieldNames ? '' : 'deadline')
    ..aOS(14, _omitFieldNames ? '' : 'declineReason')
    ..aOS(15, _omitFieldNames ? '' : 'notes')
    ..aOS(16, _omitFieldNames ? '' : 'productTitle')
    ..aOS(17, _omitFieldNames ? '' : 'productCogs')
    ..aOS(18, _omitFieldNames ? '' : 'creatorName')
    ..aOS(19, _omitFieldNames ? '' : 'creatorHandle')
    ..aOS(20, _omitFieldNames ? '' : 'creatorAvatarUrl')
    ..aInt64(21, _omitFieldNames ? '' : 'creatorFollowers')
    ..aOS(22, _omitFieldNames ? '' : 'creatorPlatform')
    ..aOM<SampleShipment>(23, _omitFieldNames ? '' : 'shipment',
        subBuilder: SampleShipment.$_createMessage)
    ..aOM<$1.Timestamp>(24, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(25, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleRequest copyWith(void Function(SampleRequest) updates) =>
      super.copyWith((message) => updates(message as SampleRequest))
          as SampleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SampleRequest() / SampleRequest.new instead')
  static SampleRequest create() => SampleRequest._();
  static $pb.GeneratedMessage $_createMessage() => SampleRequest._();
  @$core.override
  SampleRequest createEmptyInstance() => SampleRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SampleRequest>(
          SampleRequest.$_createMessage);
  static SampleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get campaignId => $_getSZ(2);
  @$pb.TagNumber(3)
  set campaignId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCampaignId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCampaignId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productId => $_getSZ(3);
  @$pb.TagNumber(4)
  set productId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creatorEntityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set creatorEntityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatorEntityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatorEntityId() => $_clearField(5);

  @$pb.TagNumber(6)
  SampleRequestStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(SampleRequestStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get quantity => $_getIZ(6);
  @$pb.TagNumber(7)
  set quantity($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuantity() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuantity() => $_clearField(7);

  @$pb.TagNumber(8)
  SampleOutcomeStatus get outcomeStatus => $_getN(7);
  @$pb.TagNumber(8)
  set outcomeStatus(SampleOutcomeStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasOutcomeStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearOutcomeStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  SampleOutcome get outcome => $_getN(8);
  @$pb.TagNumber(9)
  set outcome(SampleOutcome value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasOutcome() => $_has(8);
  @$pb.TagNumber(9)
  void clearOutcome() => $_clearField(9);
  @$pb.TagNumber(9)
  SampleOutcome ensureOutcome() => $_ensure(8);

  @$pb.TagNumber(10)
  FollowUpStatus get followUpStatus => $_getN(9);
  @$pb.TagNumber(10)
  set followUpStatus(FollowUpStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasFollowUpStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearFollowUpStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  ShippingAddress get shippingAddress => $_getN(10);
  @$pb.TagNumber(11)
  set shippingAddress(ShippingAddress value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasShippingAddress() => $_has(10);
  @$pb.TagNumber(11)
  void clearShippingAddress() => $_clearField(11);
  @$pb.TagNumber(11)
  ShippingAddress ensureShippingAddress() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get contentRequirements => $_getSZ(11);
  @$pb.TagNumber(12)
  set contentRequirements($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasContentRequirements() => $_has(11);
  @$pb.TagNumber(12)
  void clearContentRequirements() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get deadline => $_getSZ(12);
  @$pb.TagNumber(13)
  set deadline($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDeadline() => $_has(12);
  @$pb.TagNumber(13)
  void clearDeadline() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get declineReason => $_getSZ(13);
  @$pb.TagNumber(14)
  set declineReason($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDeclineReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearDeclineReason() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get notes => $_getSZ(14);
  @$pb.TagNumber(15)
  set notes($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasNotes() => $_has(14);
  @$pb.TagNumber(15)
  void clearNotes() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get productTitle => $_getSZ(15);
  @$pb.TagNumber(16)
  set productTitle($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasProductTitle() => $_has(15);
  @$pb.TagNumber(16)
  void clearProductTitle() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get productCogs => $_getSZ(16);
  @$pb.TagNumber(17)
  set productCogs($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasProductCogs() => $_has(16);
  @$pb.TagNumber(17)
  void clearProductCogs() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get creatorName => $_getSZ(17);
  @$pb.TagNumber(18)
  set creatorName($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatorName() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatorName() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get creatorHandle => $_getSZ(18);
  @$pb.TagNumber(19)
  set creatorHandle($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasCreatorHandle() => $_has(18);
  @$pb.TagNumber(19)
  void clearCreatorHandle() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get creatorAvatarUrl => $_getSZ(19);
  @$pb.TagNumber(20)
  set creatorAvatarUrl($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasCreatorAvatarUrl() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatorAvatarUrl() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get creatorFollowers => $_getI64(20);
  @$pb.TagNumber(21)
  set creatorFollowers($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasCreatorFollowers() => $_has(20);
  @$pb.TagNumber(21)
  void clearCreatorFollowers() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get creatorPlatform => $_getSZ(21);
  @$pb.TagNumber(22)
  set creatorPlatform($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasCreatorPlatform() => $_has(21);
  @$pb.TagNumber(22)
  void clearCreatorPlatform() => $_clearField(22);

  @$pb.TagNumber(23)
  SampleShipment get shipment => $_getN(22);
  @$pb.TagNumber(23)
  set shipment(SampleShipment value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasShipment() => $_has(22);
  @$pb.TagNumber(23)
  void clearShipment() => $_clearField(23);
  @$pb.TagNumber(23)
  SampleShipment ensureShipment() => $_ensure(22);

  @$pb.TagNumber(24)
  $1.Timestamp get createdAt => $_getN(23);
  @$pb.TagNumber(24)
  set createdAt($1.Timestamp value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasCreatedAt() => $_has(23);
  @$pb.TagNumber(24)
  void clearCreatedAt() => $_clearField(24);
  @$pb.TagNumber(24)
  $1.Timestamp ensureCreatedAt() => $_ensure(23);

  @$pb.TagNumber(25)
  $1.Timestamp get updatedAt => $_getN(24);
  @$pb.TagNumber(25)
  set updatedAt($1.Timestamp value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasUpdatedAt() => $_has(24);
  @$pb.TagNumber(25)
  void clearUpdatedAt() => $_clearField(25);
  @$pb.TagNumber(25)
  $1.Timestamp ensureUpdatedAt() => $_ensure(24);
}

class SeedingCampaign extends $pb.GeneratedMessage {
  factory SeedingCampaign({
    $core.String? campaignId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? objective,
    $core.String? status,
    $core.String? startDate,
    $core.String? endDate,
    $core.String? budget,
    $core.String? budgetCurrency,
    $core.Iterable<$core.String>? relatedProductIds,
    $core.int? totalRequests,
    $core.int? shippedCount,
    $core.int? publishedCount,
    $core.String? totalCost,
    $core.String? attributedRevenue,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = SeedingCampaign._();
    if (campaignId != null) result.campaignId = campaignId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (objective != null) result.objective = objective;
    if (status != null) result.status = status;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (budget != null) result.budget = budget;
    if (budgetCurrency != null) result.budgetCurrency = budgetCurrency;
    if (relatedProductIds != null)
      result.relatedProductIds.addAll(relatedProductIds);
    if (totalRequests != null) result.totalRequests = totalRequests;
    if (shippedCount != null) result.shippedCount = shippedCount;
    if (publishedCount != null) result.publishedCount = publishedCount;
    if (totalCost != null) result.totalCost = totalCost;
    if (attributedRevenue != null) result.attributedRevenue = attributedRevenue;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  SeedingCampaign._();

  factory SeedingCampaign.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingCampaign()..mergeFromBuffer(data, registry);
  factory SeedingCampaign.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingCampaign()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingCampaign',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingCampaign.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'objective')
    ..aOS(5, _omitFieldNames ? '' : 'status')
    ..aOS(6, _omitFieldNames ? '' : 'startDate')
    ..aOS(7, _omitFieldNames ? '' : 'endDate')
    ..aOS(8, _omitFieldNames ? '' : 'budget')
    ..aOS(9, _omitFieldNames ? '' : 'budgetCurrency')
    ..pPS(10, _omitFieldNames ? '' : 'relatedProductIds')
    ..aI(11, _omitFieldNames ? '' : 'totalRequests')
    ..aI(12, _omitFieldNames ? '' : 'shippedCount')
    ..aI(13, _omitFieldNames ? '' : 'publishedCount')
    ..aOS(14, _omitFieldNames ? '' : 'totalCost')
    ..aOS(15, _omitFieldNames ? '' : 'attributedRevenue')
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingCampaign clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingCampaign copyWith(void Function(SeedingCampaign) updates) =>
      super.copyWith((message) => updates(message as SeedingCampaign))
          as SeedingCampaign;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SeedingCampaign() / SeedingCampaign.new instead')
  static SeedingCampaign create() => SeedingCampaign._();
  static $pb.GeneratedMessage $_createMessage() => SeedingCampaign._();
  @$core.override
  SeedingCampaign createEmptyInstance() => SeedingCampaign._();
  @$core.pragma('dart2js:noInline')
  static SeedingCampaign getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeedingCampaign>(
          SeedingCampaign.$_createMessage);
  static SeedingCampaign? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get objective => $_getSZ(3);
  @$pb.TagNumber(4)
  set objective($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasObjective() => $_has(3);
  @$pb.TagNumber(4)
  void clearObjective() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get status => $_getSZ(4);
  @$pb.TagNumber(5)
  set status($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get startDate => $_getSZ(5);
  @$pb.TagNumber(6)
  set startDate($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStartDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartDate() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get endDate => $_getSZ(6);
  @$pb.TagNumber(7)
  set endDate($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEndDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearEndDate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get budget => $_getSZ(7);
  @$pb.TagNumber(8)
  set budget($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBudget() => $_has(7);
  @$pb.TagNumber(8)
  void clearBudget() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get budgetCurrency => $_getSZ(8);
  @$pb.TagNumber(9)
  set budgetCurrency($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBudgetCurrency() => $_has(8);
  @$pb.TagNumber(9)
  void clearBudgetCurrency() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get relatedProductIds => $_getList(9);

  @$pb.TagNumber(11)
  $core.int get totalRequests => $_getIZ(10);
  @$pb.TagNumber(11)
  set totalRequests($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTotalRequests() => $_has(10);
  @$pb.TagNumber(11)
  void clearTotalRequests() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get shippedCount => $_getIZ(11);
  @$pb.TagNumber(12)
  set shippedCount($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasShippedCount() => $_has(11);
  @$pb.TagNumber(12)
  void clearShippedCount() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get publishedCount => $_getIZ(12);
  @$pb.TagNumber(13)
  set publishedCount($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPublishedCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearPublishedCount() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get totalCost => $_getSZ(13);
  @$pb.TagNumber(14)
  set totalCost($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTotalCost() => $_has(13);
  @$pb.TagNumber(14)
  void clearTotalCost() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get attributedRevenue => $_getSZ(14);
  @$pb.TagNumber(15)
  set attributedRevenue($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAttributedRevenue() => $_has(14);
  @$pb.TagNumber(15)
  void clearAttributedRevenue() => $_clearField(15);

  @$pb.TagNumber(16)
  $1.Timestamp get createdAt => $_getN(15);
  @$pb.TagNumber(16)
  set createdAt($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureCreatedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $1.Timestamp get updatedAt => $_getN(16);
  @$pb.TagNumber(17)
  set updatedAt($1.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasUpdatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearUpdatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureUpdatedAt() => $_ensure(16);
}

class SeedingReport extends $pb.GeneratedMessage {
  factory SeedingReport({
    $core.String? campaignId,
    $core.String? workspaceId,
    $core.int? totalSamplesRequested,
    $core.int? totalSamplesApproved,
    $core.int? totalSamplesShipped,
    $core.int? totalSamplesDelivered,
    $core.int? outcomesLoggedCount,
    $core.int? pendingOutcomesCount,
    $core.String? outcomeCoverageRate,
    $core.String? totalCogs,
    $core.String? totalShipping,
    $core.String? totalCost,
    $core.String? attributableRevenue,
    $core.String? roiPercentage,
    SeedingConfidenceLevel? overallConfidence,
    $core.String? confidenceNotes,
    $core.String? currency,
    $core.bool? isMissingOutcomePending,
  }) {
    final result = SeedingReport._();
    if (campaignId != null) result.campaignId = campaignId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (totalSamplesRequested != null)
      result.totalSamplesRequested = totalSamplesRequested;
    if (totalSamplesApproved != null)
      result.totalSamplesApproved = totalSamplesApproved;
    if (totalSamplesShipped != null)
      result.totalSamplesShipped = totalSamplesShipped;
    if (totalSamplesDelivered != null)
      result.totalSamplesDelivered = totalSamplesDelivered;
    if (outcomesLoggedCount != null)
      result.outcomesLoggedCount = outcomesLoggedCount;
    if (pendingOutcomesCount != null)
      result.pendingOutcomesCount = pendingOutcomesCount;
    if (outcomeCoverageRate != null)
      result.outcomeCoverageRate = outcomeCoverageRate;
    if (totalCogs != null) result.totalCogs = totalCogs;
    if (totalShipping != null) result.totalShipping = totalShipping;
    if (totalCost != null) result.totalCost = totalCost;
    if (attributableRevenue != null)
      result.attributableRevenue = attributableRevenue;
    if (roiPercentage != null) result.roiPercentage = roiPercentage;
    if (overallConfidence != null) result.overallConfidence = overallConfidence;
    if (confidenceNotes != null) result.confidenceNotes = confidenceNotes;
    if (currency != null) result.currency = currency;
    if (isMissingOutcomePending != null)
      result.isMissingOutcomePending = isMissingOutcomePending;
    return result;
  }

  SeedingReport._();

  factory SeedingReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingReport()..mergeFromBuffer(data, registry);
  factory SeedingReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingReport()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingReport',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingReport.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aI(3, _omitFieldNames ? '' : 'totalSamplesRequested')
    ..aI(4, _omitFieldNames ? '' : 'totalSamplesApproved')
    ..aI(5, _omitFieldNames ? '' : 'totalSamplesShipped')
    ..aI(6, _omitFieldNames ? '' : 'totalSamplesDelivered')
    ..aI(7, _omitFieldNames ? '' : 'outcomesLoggedCount')
    ..aI(8, _omitFieldNames ? '' : 'pendingOutcomesCount')
    ..aOS(9, _omitFieldNames ? '' : 'outcomeCoverageRate')
    ..aOS(10, _omitFieldNames ? '' : 'totalCogs')
    ..aOS(11, _omitFieldNames ? '' : 'totalShipping')
    ..aOS(12, _omitFieldNames ? '' : 'totalCost')
    ..aOS(13, _omitFieldNames ? '' : 'attributableRevenue')
    ..aOS(14, _omitFieldNames ? '' : 'roiPercentage')
    ..aE<SeedingConfidenceLevel>(15, _omitFieldNames ? '' : 'overallConfidence',
        enumValues: SeedingConfidenceLevel.values)
    ..aOS(16, _omitFieldNames ? '' : 'confidenceNotes')
    ..aOS(17, _omitFieldNames ? '' : 'currency')
    ..aOB(18, _omitFieldNames ? '' : 'isMissingOutcomePending')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingReport copyWith(void Function(SeedingReport) updates) =>
      super.copyWith((message) => updates(message as SeedingReport))
          as SeedingReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SeedingReport() / SeedingReport.new instead')
  static SeedingReport create() => SeedingReport._();
  static $pb.GeneratedMessage $_createMessage() => SeedingReport._();
  @$core.override
  SeedingReport createEmptyInstance() => SeedingReport._();
  @$core.pragma('dart2js:noInline')
  static SeedingReport getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeedingReport>(
          SeedingReport.$_createMessage);
  static SeedingReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalSamplesRequested => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalSamplesRequested($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalSamplesRequested() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSamplesRequested() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalSamplesApproved => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalSamplesApproved($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalSamplesApproved() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSamplesApproved() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get totalSamplesShipped => $_getIZ(4);
  @$pb.TagNumber(5)
  set totalSamplesShipped($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalSamplesShipped() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalSamplesShipped() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get totalSamplesDelivered => $_getIZ(5);
  @$pb.TagNumber(6)
  set totalSamplesDelivered($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalSamplesDelivered() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalSamplesDelivered() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get outcomesLoggedCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set outcomesLoggedCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOutcomesLoggedCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearOutcomesLoggedCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get pendingOutcomesCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set pendingOutcomesCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPendingOutcomesCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearPendingOutcomesCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get outcomeCoverageRate => $_getSZ(8);
  @$pb.TagNumber(9)
  set outcomeCoverageRate($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOutcomeCoverageRate() => $_has(8);
  @$pb.TagNumber(9)
  void clearOutcomeCoverageRate() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get totalCogs => $_getSZ(9);
  @$pb.TagNumber(10)
  set totalCogs($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTotalCogs() => $_has(9);
  @$pb.TagNumber(10)
  void clearTotalCogs() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get totalShipping => $_getSZ(10);
  @$pb.TagNumber(11)
  set totalShipping($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTotalShipping() => $_has(10);
  @$pb.TagNumber(11)
  void clearTotalShipping() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get totalCost => $_getSZ(11);
  @$pb.TagNumber(12)
  set totalCost($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTotalCost() => $_has(11);
  @$pb.TagNumber(12)
  void clearTotalCost() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get attributableRevenue => $_getSZ(12);
  @$pb.TagNumber(13)
  set attributableRevenue($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAttributableRevenue() => $_has(12);
  @$pb.TagNumber(13)
  void clearAttributableRevenue() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get roiPercentage => $_getSZ(13);
  @$pb.TagNumber(14)
  set roiPercentage($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRoiPercentage() => $_has(13);
  @$pb.TagNumber(14)
  void clearRoiPercentage() => $_clearField(14);

  @$pb.TagNumber(15)
  SeedingConfidenceLevel get overallConfidence => $_getN(14);
  @$pb.TagNumber(15)
  set overallConfidence(SeedingConfidenceLevel value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasOverallConfidence() => $_has(14);
  @$pb.TagNumber(15)
  void clearOverallConfidence() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get confidenceNotes => $_getSZ(15);
  @$pb.TagNumber(16)
  set confidenceNotes($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasConfidenceNotes() => $_has(15);
  @$pb.TagNumber(16)
  void clearConfidenceNotes() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get currency => $_getSZ(16);
  @$pb.TagNumber(17)
  set currency($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCurrency() => $_has(16);
  @$pb.TagNumber(17)
  void clearCurrency() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get isMissingOutcomePending => $_getBF(17);
  @$pb.TagNumber(18)
  set isMissingOutcomePending($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasIsMissingOutcomePending() => $_has(17);
  @$pb.TagNumber(18)
  void clearIsMissingOutcomePending() => $_clearField(18);
}

class SeedingServiceCreateSampleRequest extends $pb.GeneratedMessage {
  factory SeedingServiceCreateSampleRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? productId,
    $core.String? creatorEntityId,
    $core.int? quantity,
    ShippingAddress? shippingAddress,
    $core.String? contentRequirements,
    $core.String? deadline,
    $core.String? notes,
  }) {
    final result = SeedingServiceCreateSampleRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (productId != null) result.productId = productId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (quantity != null) result.quantity = quantity;
    if (shippingAddress != null) result.shippingAddress = shippingAddress;
    if (contentRequirements != null)
      result.contentRequirements = contentRequirements;
    if (deadline != null) result.deadline = deadline;
    if (notes != null) result.notes = notes;
    return result;
  }

  SeedingServiceCreateSampleRequest._();

  factory SeedingServiceCreateSampleRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateSampleRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceCreateSampleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateSampleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceCreateSampleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceCreateSampleRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'campaignId')
    ..aOS(4, _omitFieldNames ? '' : 'productId')
    ..aOS(5, _omitFieldNames ? '' : 'creatorEntityId')
    ..aI(6, _omitFieldNames ? '' : 'quantity')
    ..aOM<ShippingAddress>(7, _omitFieldNames ? '' : 'shippingAddress',
        subBuilder: ShippingAddress.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'contentRequirements')
    ..aOS(9, _omitFieldNames ? '' : 'deadline')
    ..aOS(10, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateSampleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateSampleRequest copyWith(
          void Function(SeedingServiceCreateSampleRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceCreateSampleRequest))
          as SeedingServiceCreateSampleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceCreateSampleRequest() / SeedingServiceCreateSampleRequest.new instead')
  static SeedingServiceCreateSampleRequest create() =>
      SeedingServiceCreateSampleRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceCreateSampleRequest._();
  @$core.override
  SeedingServiceCreateSampleRequest createEmptyInstance() =>
      SeedingServiceCreateSampleRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceCreateSampleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceCreateSampleRequest>(
          SeedingServiceCreateSampleRequest.$_createMessage);
  static SeedingServiceCreateSampleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get campaignId => $_getSZ(2);
  @$pb.TagNumber(3)
  set campaignId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCampaignId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCampaignId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productId => $_getSZ(3);
  @$pb.TagNumber(4)
  set productId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creatorEntityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set creatorEntityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatorEntityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatorEntityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get quantity => $_getIZ(5);
  @$pb.TagNumber(6)
  set quantity($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuantity() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuantity() => $_clearField(6);

  @$pb.TagNumber(7)
  ShippingAddress get shippingAddress => $_getN(6);
  @$pb.TagNumber(7)
  set shippingAddress(ShippingAddress value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasShippingAddress() => $_has(6);
  @$pb.TagNumber(7)
  void clearShippingAddress() => $_clearField(7);
  @$pb.TagNumber(7)
  ShippingAddress ensureShippingAddress() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get contentRequirements => $_getSZ(7);
  @$pb.TagNumber(8)
  set contentRequirements($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasContentRequirements() => $_has(7);
  @$pb.TagNumber(8)
  void clearContentRequirements() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get deadline => $_getSZ(8);
  @$pb.TagNumber(9)
  set deadline($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeadline() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeadline() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get notes => $_getSZ(9);
  @$pb.TagNumber(10)
  set notes($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNotes() => $_has(9);
  @$pb.TagNumber(10)
  void clearNotes() => $_clearField(10);
}

class SeedingServiceCreateSampleResponse extends $pb.GeneratedMessage {
  factory SeedingServiceCreateSampleResponse({
    SampleRequest? sampleRequest,
    $core.bool? alreadyExisted,
  }) {
    final result = SeedingServiceCreateSampleResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    if (alreadyExisted != null) result.alreadyExisted = alreadyExisted;
    return result;
  }

  SeedingServiceCreateSampleResponse._();

  factory SeedingServiceCreateSampleResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateSampleResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceCreateSampleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateSampleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceCreateSampleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceCreateSampleResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'alreadyExisted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateSampleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateSampleResponse copyWith(
          void Function(SeedingServiceCreateSampleResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceCreateSampleResponse))
          as SeedingServiceCreateSampleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceCreateSampleResponse() / SeedingServiceCreateSampleResponse.new instead')
  static SeedingServiceCreateSampleResponse create() =>
      SeedingServiceCreateSampleResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceCreateSampleResponse._();
  @$core.override
  SeedingServiceCreateSampleResponse createEmptyInstance() =>
      SeedingServiceCreateSampleResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceCreateSampleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceCreateSampleResponse>(
          SeedingServiceCreateSampleResponse.$_createMessage);
  static SeedingServiceCreateSampleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get alreadyExisted => $_getBF(1);
  @$pb.TagNumber(2)
  set alreadyExisted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlreadyExisted() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlreadyExisted() => $_clearField(2);
}

class SeedingServiceGetRequest extends $pb.GeneratedMessage {
  factory SeedingServiceGetRequest({
    $core.String? workspaceId,
    $core.String? requestId,
  }) {
    final result = SeedingServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  SeedingServiceGetRequest._();

  factory SeedingServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceGetRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceGetRequest copyWith(
          void Function(SeedingServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as SeedingServiceGetRequest))
          as SeedingServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceGetRequest() / SeedingServiceGetRequest.new instead')
  static SeedingServiceGetRequest create() => SeedingServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => SeedingServiceGetRequest._();
  @$core.override
  SeedingServiceGetRequest createEmptyInstance() =>
      SeedingServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceGetRequest>(
          SeedingServiceGetRequest.$_createMessage);
  static SeedingServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);
}

class SeedingServiceGetResponse extends $pb.GeneratedMessage {
  factory SeedingServiceGetResponse({
    SampleRequest? sampleRequest,
  }) {
    final result = SeedingServiceGetResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SeedingServiceGetResponse._();

  factory SeedingServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceGetResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceGetResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceGetResponse copyWith(
          void Function(SeedingServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as SeedingServiceGetResponse))
          as SeedingServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceGetResponse() / SeedingServiceGetResponse.new instead')
  static SeedingServiceGetResponse create() => SeedingServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceGetResponse._();
  @$core.override
  SeedingServiceGetResponse createEmptyInstance() =>
      SeedingServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceGetResponse>(
          SeedingServiceGetResponse.$_createMessage);
  static SeedingServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);
}

class SeedingServiceListRequest extends $pb.GeneratedMessage {
  factory SeedingServiceListRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? productId,
    $core.String? creatorEntityId,
    SampleRequestStatus? status,
    SampleOutcomeStatus? outcomeStatus,
    FollowUpStatus? followUpStatus,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = SeedingServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (productId != null) result.productId = productId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (status != null) result.status = status;
    if (outcomeStatus != null) result.outcomeStatus = outcomeStatus;
    if (followUpStatus != null) result.followUpStatus = followUpStatus;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  SeedingServiceListRequest._();

  factory SeedingServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'productId')
    ..aOS(4, _omitFieldNames ? '' : 'creatorEntityId')
    ..aE<SampleRequestStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: SampleRequestStatus.values)
    ..aE<SampleOutcomeStatus>(6, _omitFieldNames ? '' : 'outcomeStatus',
        enumValues: SampleOutcomeStatus.values)
    ..aE<FollowUpStatus>(7, _omitFieldNames ? '' : 'followUpStatus',
        enumValues: FollowUpStatus.values)
    ..aI(8, _omitFieldNames ? '' : 'limit')
    ..aI(9, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListRequest copyWith(
          void Function(SeedingServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as SeedingServiceListRequest))
          as SeedingServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceListRequest() / SeedingServiceListRequest.new instead')
  static SeedingServiceListRequest create() => SeedingServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceListRequest._();
  @$core.override
  SeedingServiceListRequest createEmptyInstance() =>
      SeedingServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceListRequest>(
          SeedingServiceListRequest.$_createMessage);
  static SeedingServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get productId => $_getSZ(2);
  @$pb.TagNumber(3)
  set productId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProductId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creatorEntityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set creatorEntityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatorEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatorEntityId() => $_clearField(4);

  @$pb.TagNumber(5)
  SampleRequestStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(SampleRequestStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  SampleOutcomeStatus get outcomeStatus => $_getN(5);
  @$pb.TagNumber(6)
  set outcomeStatus(SampleOutcomeStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOutcomeStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearOutcomeStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  FollowUpStatus get followUpStatus => $_getN(6);
  @$pb.TagNumber(7)
  set followUpStatus(FollowUpStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFollowUpStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollowUpStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get limit => $_getIZ(7);
  @$pb.TagNumber(8)
  set limit($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLimit() => $_has(7);
  @$pb.TagNumber(8)
  void clearLimit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get offset => $_getIZ(8);
  @$pb.TagNumber(9)
  set offset($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOffset() => $_has(8);
  @$pb.TagNumber(9)
  void clearOffset() => $_clearField(9);
}

class SeedingServiceListResponse extends $pb.GeneratedMessage {
  factory SeedingServiceListResponse({
    $core.Iterable<SampleRequest>? sampleRequests,
    $fixnum.Int64? totalCount,
    $core.int? requestedCount,
    $core.int? approvedCount,
    $core.int? shippedCount,
    $core.int? receivedCount,
    $core.int? reviewPublishedCount,
  }) {
    final result = SeedingServiceListResponse._();
    if (sampleRequests != null) result.sampleRequests.addAll(sampleRequests);
    if (totalCount != null) result.totalCount = totalCount;
    if (requestedCount != null) result.requestedCount = requestedCount;
    if (approvedCount != null) result.approvedCount = approvedCount;
    if (shippedCount != null) result.shippedCount = shippedCount;
    if (receivedCount != null) result.receivedCount = receivedCount;
    if (reviewPublishedCount != null)
      result.reviewPublishedCount = reviewPublishedCount;
    return result;
  }

  SeedingServiceListResponse._();

  factory SeedingServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceListResponse.$_createMessage)
    ..pPM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequests',
        subBuilder: SampleRequest.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'totalCount')
    ..aI(3, _omitFieldNames ? '' : 'requestedCount')
    ..aI(4, _omitFieldNames ? '' : 'approvedCount')
    ..aI(5, _omitFieldNames ? '' : 'shippedCount')
    ..aI(6, _omitFieldNames ? '' : 'receivedCount')
    ..aI(7, _omitFieldNames ? '' : 'reviewPublishedCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListResponse copyWith(
          void Function(SeedingServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceListResponse))
          as SeedingServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceListResponse() / SeedingServiceListResponse.new instead')
  static SeedingServiceListResponse create() => SeedingServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceListResponse._();
  @$core.override
  SeedingServiceListResponse createEmptyInstance() =>
      SeedingServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceListResponse>(
          SeedingServiceListResponse.$_createMessage);
  static SeedingServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SampleRequest> get sampleRequests => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalCount => $_getI64(1);
  @$pb.TagNumber(2)
  set totalCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get requestedCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set requestedCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestedCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestedCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get approvedCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set approvedCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasApprovedCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearApprovedCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get shippedCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set shippedCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShippedCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearShippedCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get receivedCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set receivedCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReceivedCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearReceivedCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get reviewPublishedCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set reviewPublishedCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReviewPublishedCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearReviewPublishedCount() => $_clearField(7);
}

class SeedingServiceApproveRequest extends $pb.GeneratedMessage {
  factory SeedingServiceApproveRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? requestId,
  }) {
    final result = SeedingServiceApproveRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  SeedingServiceApproveRequest._();

  factory SeedingServiceApproveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceApproveRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceApproveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceApproveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceApproveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceApproveRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceApproveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceApproveRequest copyWith(
          void Function(SeedingServiceApproveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceApproveRequest))
          as SeedingServiceApproveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceApproveRequest() / SeedingServiceApproveRequest.new instead')
  static SeedingServiceApproveRequest create() =>
      SeedingServiceApproveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceApproveRequest._();
  @$core.override
  SeedingServiceApproveRequest createEmptyInstance() =>
      SeedingServiceApproveRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceApproveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceApproveRequest>(
          SeedingServiceApproveRequest.$_createMessage);
  static SeedingServiceApproveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestId() => $_clearField(3);
}

class SeedingServiceApproveResponse extends $pb.GeneratedMessage {
  factory SeedingServiceApproveResponse({
    SampleRequest? sampleRequest,
    $core.String? costItemId,
    $core.String? costAmount,
    $core.String? currency,
    $core.bool? replayed,
  }) {
    final result = SeedingServiceApproveResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    if (costItemId != null) result.costItemId = costItemId;
    if (costAmount != null) result.costAmount = costAmount;
    if (currency != null) result.currency = currency;
    if (replayed != null) result.replayed = replayed;
    return result;
  }

  SeedingServiceApproveResponse._();

  factory SeedingServiceApproveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceApproveResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceApproveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceApproveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceApproveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceApproveResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'costItemId')
    ..aOS(3, _omitFieldNames ? '' : 'costAmount')
    ..aOS(4, _omitFieldNames ? '' : 'currency')
    ..aOB(5, _omitFieldNames ? '' : 'replayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceApproveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceApproveResponse copyWith(
          void Function(SeedingServiceApproveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceApproveResponse))
          as SeedingServiceApproveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceApproveResponse() / SeedingServiceApproveResponse.new instead')
  static SeedingServiceApproveResponse create() =>
      SeedingServiceApproveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceApproveResponse._();
  @$core.override
  SeedingServiceApproveResponse createEmptyInstance() =>
      SeedingServiceApproveResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceApproveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceApproveResponse>(
          SeedingServiceApproveResponse.$_createMessage);
  static SeedingServiceApproveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get costItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set costItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCostItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCostItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get costAmount => $_getSZ(2);
  @$pb.TagNumber(3)
  set costAmount($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCostAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCostAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get currency => $_getSZ(3);
  @$pb.TagNumber(4)
  set currency($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrency() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrency() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get replayed => $_getBF(4);
  @$pb.TagNumber(5)
  set replayed($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReplayed() => $_has(4);
  @$pb.TagNumber(5)
  void clearReplayed() => $_clearField(5);
}

class SeedingServiceShipRequest extends $pb.GeneratedMessage {
  factory SeedingServiceShipRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? requestId,
    $core.String? carrier,
    $core.String? trackingNumber,
    $core.String? shippingCost,
  }) {
    final result = SeedingServiceShipRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (carrier != null) result.carrier = carrier;
    if (trackingNumber != null) result.trackingNumber = trackingNumber;
    if (shippingCost != null) result.shippingCost = shippingCost;
    return result;
  }

  SeedingServiceShipRequest._();

  factory SeedingServiceShipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceShipRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceShipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceShipRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceShipRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceShipRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'requestId')
    ..aOS(4, _omitFieldNames ? '' : 'carrier')
    ..aOS(5, _omitFieldNames ? '' : 'trackingNumber')
    ..aOS(6, _omitFieldNames ? '' : 'shippingCost')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceShipRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceShipRequest copyWith(
          void Function(SeedingServiceShipRequest) updates) =>
      super.copyWith((message) => updates(message as SeedingServiceShipRequest))
          as SeedingServiceShipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceShipRequest() / SeedingServiceShipRequest.new instead')
  static SeedingServiceShipRequest create() => SeedingServiceShipRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceShipRequest._();
  @$core.override
  SeedingServiceShipRequest createEmptyInstance() =>
      SeedingServiceShipRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceShipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceShipRequest>(
          SeedingServiceShipRequest.$_createMessage);
  static SeedingServiceShipRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get carrier => $_getSZ(3);
  @$pb.TagNumber(4)
  set carrier($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCarrier() => $_has(3);
  @$pb.TagNumber(4)
  void clearCarrier() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get trackingNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set trackingNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTrackingNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrackingNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get shippingCost => $_getSZ(5);
  @$pb.TagNumber(6)
  set shippingCost($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShippingCost() => $_has(5);
  @$pb.TagNumber(6)
  void clearShippingCost() => $_clearField(6);
}

class SeedingServiceShipResponse extends $pb.GeneratedMessage {
  factory SeedingServiceShipResponse({
    SampleRequest? sampleRequest,
    SampleShipment? shipment,
    $core.String? totalUpdatedCost,
    $core.bool? replayed,
  }) {
    final result = SeedingServiceShipResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    if (shipment != null) result.shipment = shipment;
    if (totalUpdatedCost != null) result.totalUpdatedCost = totalUpdatedCost;
    if (replayed != null) result.replayed = replayed;
    return result;
  }

  SeedingServiceShipResponse._();

  factory SeedingServiceShipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceShipResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceShipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceShipResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceShipResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceShipResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..aOM<SampleShipment>(2, _omitFieldNames ? '' : 'shipment',
        subBuilder: SampleShipment.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'totalUpdatedCost')
    ..aOB(4, _omitFieldNames ? '' : 'replayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceShipResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceShipResponse copyWith(
          void Function(SeedingServiceShipResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceShipResponse))
          as SeedingServiceShipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceShipResponse() / SeedingServiceShipResponse.new instead')
  static SeedingServiceShipResponse create() => SeedingServiceShipResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceShipResponse._();
  @$core.override
  SeedingServiceShipResponse createEmptyInstance() =>
      SeedingServiceShipResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceShipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceShipResponse>(
          SeedingServiceShipResponse.$_createMessage);
  static SeedingServiceShipResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  SampleShipment get shipment => $_getN(1);
  @$pb.TagNumber(2)
  set shipment(SampleShipment value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasShipment() => $_has(1);
  @$pb.TagNumber(2)
  void clearShipment() => $_clearField(2);
  @$pb.TagNumber(2)
  SampleShipment ensureShipment() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get totalUpdatedCost => $_getSZ(2);
  @$pb.TagNumber(3)
  set totalUpdatedCost($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalUpdatedCost() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalUpdatedCost() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get replayed => $_getBF(3);
  @$pb.TagNumber(4)
  set replayed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReplayed() => $_has(3);
  @$pb.TagNumber(4)
  void clearReplayed() => $_clearField(4);
}

class SeedingServiceTrackDeliveryRequest extends $pb.GeneratedMessage {
  factory SeedingServiceTrackDeliveryRequest({
    $core.String? workspaceId,
    $core.String? shipmentId,
  }) {
    final result = SeedingServiceTrackDeliveryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (shipmentId != null) result.shipmentId = shipmentId;
    return result;
  }

  SeedingServiceTrackDeliveryRequest._();

  factory SeedingServiceTrackDeliveryRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceTrackDeliveryRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceTrackDeliveryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceTrackDeliveryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceTrackDeliveryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceTrackDeliveryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'shipmentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceTrackDeliveryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceTrackDeliveryRequest copyWith(
          void Function(SeedingServiceTrackDeliveryRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceTrackDeliveryRequest))
          as SeedingServiceTrackDeliveryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceTrackDeliveryRequest() / SeedingServiceTrackDeliveryRequest.new instead')
  static SeedingServiceTrackDeliveryRequest create() =>
      SeedingServiceTrackDeliveryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceTrackDeliveryRequest._();
  @$core.override
  SeedingServiceTrackDeliveryRequest createEmptyInstance() =>
      SeedingServiceTrackDeliveryRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceTrackDeliveryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceTrackDeliveryRequest>(
          SeedingServiceTrackDeliveryRequest.$_createMessage);
  static SeedingServiceTrackDeliveryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shipmentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set shipmentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShipmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearShipmentId() => $_clearField(2);
}

class SeedingServiceTrackDeliveryResponse extends $pb.GeneratedMessage {
  factory SeedingServiceTrackDeliveryResponse({
    SampleShipment? shipment,
    $core.String? carrierStatus,
    $1.Timestamp? estimatedDelivery,
  }) {
    final result = SeedingServiceTrackDeliveryResponse._();
    if (shipment != null) result.shipment = shipment;
    if (carrierStatus != null) result.carrierStatus = carrierStatus;
    if (estimatedDelivery != null) result.estimatedDelivery = estimatedDelivery;
    return result;
  }

  SeedingServiceTrackDeliveryResponse._();

  factory SeedingServiceTrackDeliveryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceTrackDeliveryResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceTrackDeliveryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceTrackDeliveryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceTrackDeliveryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceTrackDeliveryResponse.$_createMessage)
    ..aOM<SampleShipment>(1, _omitFieldNames ? '' : 'shipment',
        subBuilder: SampleShipment.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'carrierStatus')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'estimatedDelivery',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceTrackDeliveryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceTrackDeliveryResponse copyWith(
          void Function(SeedingServiceTrackDeliveryResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceTrackDeliveryResponse))
          as SeedingServiceTrackDeliveryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceTrackDeliveryResponse() / SeedingServiceTrackDeliveryResponse.new instead')
  static SeedingServiceTrackDeliveryResponse create() =>
      SeedingServiceTrackDeliveryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceTrackDeliveryResponse._();
  @$core.override
  SeedingServiceTrackDeliveryResponse createEmptyInstance() =>
      SeedingServiceTrackDeliveryResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceTrackDeliveryResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceTrackDeliveryResponse>(
          SeedingServiceTrackDeliveryResponse.$_createMessage);
  static SeedingServiceTrackDeliveryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleShipment get shipment => $_getN(0);
  @$pb.TagNumber(1)
  set shipment(SampleShipment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasShipment() => $_has(0);
  @$pb.TagNumber(1)
  void clearShipment() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleShipment ensureShipment() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get carrierStatus => $_getSZ(1);
  @$pb.TagNumber(2)
  set carrierStatus($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCarrierStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearCarrierStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get estimatedDelivery => $_getN(2);
  @$pb.TagNumber(3)
  set estimatedDelivery($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEstimatedDelivery() => $_has(2);
  @$pb.TagNumber(3)
  void clearEstimatedDelivery() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureEstimatedDelivery() => $_ensure(2);
}

class SeedingServiceGetReportRequest extends $pb.GeneratedMessage {
  factory SeedingServiceGetReportRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = SeedingServiceGetReportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  SeedingServiceGetReportRequest._();

  factory SeedingServiceGetReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceGetReportRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceGetReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceGetReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceGetReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceGetReportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceGetReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceGetReportRequest copyWith(
          void Function(SeedingServiceGetReportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceGetReportRequest))
          as SeedingServiceGetReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceGetReportRequest() / SeedingServiceGetReportRequest.new instead')
  static SeedingServiceGetReportRequest create() =>
      SeedingServiceGetReportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceGetReportRequest._();
  @$core.override
  SeedingServiceGetReportRequest createEmptyInstance() =>
      SeedingServiceGetReportRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceGetReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceGetReportRequest>(
          SeedingServiceGetReportRequest.$_createMessage);
  static SeedingServiceGetReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class SeedingServiceGetReportResponse extends $pb.GeneratedMessage {
  factory SeedingServiceGetReportResponse({
    SeedingReport? report,
  }) {
    final result = SeedingServiceGetReportResponse._();
    if (report != null) result.report = report;
    return result;
  }

  SeedingServiceGetReportResponse._();

  factory SeedingServiceGetReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceGetReportResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceGetReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceGetReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceGetReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceGetReportResponse.$_createMessage)
    ..aOM<SeedingReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: SeedingReport.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceGetReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceGetReportResponse copyWith(
          void Function(SeedingServiceGetReportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceGetReportResponse))
          as SeedingServiceGetReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceGetReportResponse() / SeedingServiceGetReportResponse.new instead')
  static SeedingServiceGetReportResponse create() =>
      SeedingServiceGetReportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceGetReportResponse._();
  @$core.override
  SeedingServiceGetReportResponse createEmptyInstance() =>
      SeedingServiceGetReportResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceGetReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceGetReportResponse>(
          SeedingServiceGetReportResponse.$_createMessage);
  static SeedingServiceGetReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SeedingReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(SeedingReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  SeedingReport ensureReport() => $_ensure(0);
}

class SeedingServiceCreateCampaignRequest extends $pb.GeneratedMessage {
  factory SeedingServiceCreateCampaignRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? objective,
    $core.String? startDate,
    $core.String? endDate,
    $core.String? budget,
    $core.String? budgetCurrency,
    $core.Iterable<$core.String>? relatedProductIds,
  }) {
    final result = SeedingServiceCreateCampaignRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (objective != null) result.objective = objective;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (budget != null) result.budget = budget;
    if (budgetCurrency != null) result.budgetCurrency = budgetCurrency;
    if (relatedProductIds != null)
      result.relatedProductIds.addAll(relatedProductIds);
    return result;
  }

  SeedingServiceCreateCampaignRequest._();

  factory SeedingServiceCreateCampaignRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateCampaignRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceCreateCampaignRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateCampaignRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceCreateCampaignRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceCreateCampaignRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'objective')
    ..aOS(5, _omitFieldNames ? '' : 'startDate')
    ..aOS(6, _omitFieldNames ? '' : 'endDate')
    ..aOS(7, _omitFieldNames ? '' : 'budget')
    ..aOS(8, _omitFieldNames ? '' : 'budgetCurrency')
    ..pPS(9, _omitFieldNames ? '' : 'relatedProductIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateCampaignRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateCampaignRequest copyWith(
          void Function(SeedingServiceCreateCampaignRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceCreateCampaignRequest))
          as SeedingServiceCreateCampaignRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceCreateCampaignRequest() / SeedingServiceCreateCampaignRequest.new instead')
  static SeedingServiceCreateCampaignRequest create() =>
      SeedingServiceCreateCampaignRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceCreateCampaignRequest._();
  @$core.override
  SeedingServiceCreateCampaignRequest createEmptyInstance() =>
      SeedingServiceCreateCampaignRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceCreateCampaignRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceCreateCampaignRequest>(
          SeedingServiceCreateCampaignRequest.$_createMessage);
  static SeedingServiceCreateCampaignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get objective => $_getSZ(3);
  @$pb.TagNumber(4)
  set objective($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasObjective() => $_has(3);
  @$pb.TagNumber(4)
  void clearObjective() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get startDate => $_getSZ(4);
  @$pb.TagNumber(5)
  set startDate($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartDate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get endDate => $_getSZ(5);
  @$pb.TagNumber(6)
  set endDate($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEndDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndDate() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get budget => $_getSZ(6);
  @$pb.TagNumber(7)
  set budget($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBudget() => $_has(6);
  @$pb.TagNumber(7)
  void clearBudget() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get budgetCurrency => $_getSZ(7);
  @$pb.TagNumber(8)
  set budgetCurrency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBudgetCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearBudgetCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get relatedProductIds => $_getList(8);
}

class SeedingServiceCreateCampaignResponse extends $pb.GeneratedMessage {
  factory SeedingServiceCreateCampaignResponse({
    SeedingCampaign? campaign,
  }) {
    final result = SeedingServiceCreateCampaignResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  SeedingServiceCreateCampaignResponse._();

  factory SeedingServiceCreateCampaignResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateCampaignResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceCreateCampaignResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateCampaignResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceCreateCampaignResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceCreateCampaignResponse.$_createMessage)
    ..aOM<SeedingCampaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: SeedingCampaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateCampaignResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateCampaignResponse copyWith(
          void Function(SeedingServiceCreateCampaignResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceCreateCampaignResponse))
          as SeedingServiceCreateCampaignResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceCreateCampaignResponse() / SeedingServiceCreateCampaignResponse.new instead')
  static SeedingServiceCreateCampaignResponse create() =>
      SeedingServiceCreateCampaignResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceCreateCampaignResponse._();
  @$core.override
  SeedingServiceCreateCampaignResponse createEmptyInstance() =>
      SeedingServiceCreateCampaignResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceCreateCampaignResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceCreateCampaignResponse>(
          SeedingServiceCreateCampaignResponse.$_createMessage);
  static SeedingServiceCreateCampaignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SeedingCampaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(SeedingCampaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  SeedingCampaign ensureCampaign() => $_ensure(0);
}

class SeedingServiceListCampaignsRequest extends $pb.GeneratedMessage {
  factory SeedingServiceListCampaignsRequest({
    $core.String? workspaceId,
    $core.String? status,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = SeedingServiceListCampaignsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (status != null) result.status = status;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  SeedingServiceListCampaignsRequest._();

  factory SeedingServiceListCampaignsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListCampaignsRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceListCampaignsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListCampaignsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceListCampaignsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceListCampaignsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..aI(4, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListCampaignsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListCampaignsRequest copyWith(
          void Function(SeedingServiceListCampaignsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceListCampaignsRequest))
          as SeedingServiceListCampaignsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceListCampaignsRequest() / SeedingServiceListCampaignsRequest.new instead')
  static SeedingServiceListCampaignsRequest create() =>
      SeedingServiceListCampaignsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceListCampaignsRequest._();
  @$core.override
  SeedingServiceListCampaignsRequest createEmptyInstance() =>
      SeedingServiceListCampaignsRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceListCampaignsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceListCampaignsRequest>(
          SeedingServiceListCampaignsRequest.$_createMessage);
  static SeedingServiceListCampaignsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class SeedingServiceListCampaignsResponse extends $pb.GeneratedMessage {
  factory SeedingServiceListCampaignsResponse({
    $core.Iterable<SeedingCampaign>? campaigns,
    $fixnum.Int64? totalCount,
  }) {
    final result = SeedingServiceListCampaignsResponse._();
    if (campaigns != null) result.campaigns.addAll(campaigns);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  SeedingServiceListCampaignsResponse._();

  factory SeedingServiceListCampaignsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListCampaignsResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceListCampaignsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListCampaignsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceListCampaignsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceListCampaignsResponse.$_createMessage)
    ..pPM<SeedingCampaign>(1, _omitFieldNames ? '' : 'campaigns',
        subBuilder: SeedingCampaign.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListCampaignsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListCampaignsResponse copyWith(
          void Function(SeedingServiceListCampaignsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceListCampaignsResponse))
          as SeedingServiceListCampaignsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceListCampaignsResponse() / SeedingServiceListCampaignsResponse.new instead')
  static SeedingServiceListCampaignsResponse create() =>
      SeedingServiceListCampaignsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceListCampaignsResponse._();
  @$core.override
  SeedingServiceListCampaignsResponse createEmptyInstance() =>
      SeedingServiceListCampaignsResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceListCampaignsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceListCampaignsResponse>(
          SeedingServiceListCampaignsResponse.$_createMessage);
  static SeedingServiceListCampaignsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SeedingCampaign> get campaigns => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalCount => $_getI64(1);
  @$pb.TagNumber(2)
  set totalCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class SeedingServiceCreateAssignmentRequest extends $pb.GeneratedMessage {
  factory SeedingServiceCreateAssignmentRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? creatorEntityId,
    $core.String? productId,
    $core.String? notes,
  }) {
    final result = SeedingServiceCreateAssignmentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (productId != null) result.productId = productId;
    if (notes != null) result.notes = notes;
    return result;
  }

  SeedingServiceCreateAssignmentRequest._();

  factory SeedingServiceCreateAssignmentRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateAssignmentRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceCreateAssignmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateAssignmentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceCreateAssignmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          SeedingServiceCreateAssignmentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'creatorEntityId')
    ..aOS(4, _omitFieldNames ? '' : 'productId')
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateAssignmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateAssignmentRequest copyWith(
          void Function(SeedingServiceCreateAssignmentRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceCreateAssignmentRequest))
          as SeedingServiceCreateAssignmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceCreateAssignmentRequest() / SeedingServiceCreateAssignmentRequest.new instead')
  static SeedingServiceCreateAssignmentRequest create() =>
      SeedingServiceCreateAssignmentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceCreateAssignmentRequest._();
  @$core.override
  SeedingServiceCreateAssignmentRequest createEmptyInstance() =>
      SeedingServiceCreateAssignmentRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceCreateAssignmentRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceCreateAssignmentRequest>(
          SeedingServiceCreateAssignmentRequest.$_createMessage);
  static SeedingServiceCreateAssignmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get creatorEntityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set creatorEntityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatorEntityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatorEntityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productId => $_getSZ(3);
  @$pb.TagNumber(4)
  set productId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);
}

class SeedingServiceCreateAssignmentResponse extends $pb.GeneratedMessage {
  factory SeedingServiceCreateAssignmentResponse({
    $core.String? assignmentId,
    SampleRequest? sampleRequest,
  }) {
    final result = SeedingServiceCreateAssignmentResponse._();
    if (assignmentId != null) result.assignmentId = assignmentId;
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SeedingServiceCreateAssignmentResponse._();

  factory SeedingServiceCreateAssignmentResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateAssignmentResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceCreateAssignmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceCreateAssignmentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceCreateAssignmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          SeedingServiceCreateAssignmentResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assignmentId')
    ..aOM<SampleRequest>(2, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateAssignmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceCreateAssignmentResponse copyWith(
          void Function(SeedingServiceCreateAssignmentResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceCreateAssignmentResponse))
          as SeedingServiceCreateAssignmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceCreateAssignmentResponse() / SeedingServiceCreateAssignmentResponse.new instead')
  static SeedingServiceCreateAssignmentResponse create() =>
      SeedingServiceCreateAssignmentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceCreateAssignmentResponse._();
  @$core.override
  SeedingServiceCreateAssignmentResponse createEmptyInstance() =>
      SeedingServiceCreateAssignmentResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceCreateAssignmentResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceCreateAssignmentResponse>(
          SeedingServiceCreateAssignmentResponse.$_createMessage);
  static SeedingServiceCreateAssignmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assignmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assignmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssignmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssignmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  SampleRequest get sampleRequest => $_getN(1);
  @$pb.TagNumber(2)
  set sampleRequest(SampleRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSampleRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearSampleRequest() => $_clearField(2);
  @$pb.TagNumber(2)
  SampleRequest ensureSampleRequest() => $_ensure(1);
}

class SeedingServiceRemoveAssignmentRequest extends $pb.GeneratedMessage {
  factory SeedingServiceRemoveAssignmentRequest({
    $core.String? workspaceId,
    $core.String? assignmentId,
  }) {
    final result = SeedingServiceRemoveAssignmentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assignmentId != null) result.assignmentId = assignmentId;
    return result;
  }

  SeedingServiceRemoveAssignmentRequest._();

  factory SeedingServiceRemoveAssignmentRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceRemoveAssignmentRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceRemoveAssignmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceRemoveAssignmentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceRemoveAssignmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          SeedingServiceRemoveAssignmentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'assignmentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceRemoveAssignmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceRemoveAssignmentRequest copyWith(
          void Function(SeedingServiceRemoveAssignmentRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceRemoveAssignmentRequest))
          as SeedingServiceRemoveAssignmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceRemoveAssignmentRequest() / SeedingServiceRemoveAssignmentRequest.new instead')
  static SeedingServiceRemoveAssignmentRequest create() =>
      SeedingServiceRemoveAssignmentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceRemoveAssignmentRequest._();
  @$core.override
  SeedingServiceRemoveAssignmentRequest createEmptyInstance() =>
      SeedingServiceRemoveAssignmentRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceRemoveAssignmentRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceRemoveAssignmentRequest>(
          SeedingServiceRemoveAssignmentRequest.$_createMessage);
  static SeedingServiceRemoveAssignmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assignmentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assignmentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssignmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssignmentId() => $_clearField(2);
}

class SeedingServiceRemoveAssignmentResponse extends $pb.GeneratedMessage {
  factory SeedingServiceRemoveAssignmentResponse({
    $core.bool? success,
  }) {
    final result = SeedingServiceRemoveAssignmentResponse._();
    if (success != null) result.success = success;
    return result;
  }

  SeedingServiceRemoveAssignmentResponse._();

  factory SeedingServiceRemoveAssignmentResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceRemoveAssignmentResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceRemoveAssignmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceRemoveAssignmentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceRemoveAssignmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          SeedingServiceRemoveAssignmentResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceRemoveAssignmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceRemoveAssignmentResponse copyWith(
          void Function(SeedingServiceRemoveAssignmentResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceRemoveAssignmentResponse))
          as SeedingServiceRemoveAssignmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceRemoveAssignmentResponse() / SeedingServiceRemoveAssignmentResponse.new instead')
  static SeedingServiceRemoveAssignmentResponse create() =>
      SeedingServiceRemoveAssignmentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceRemoveAssignmentResponse._();
  @$core.override
  SeedingServiceRemoveAssignmentResponse createEmptyInstance() =>
      SeedingServiceRemoveAssignmentResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceRemoveAssignmentResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceRemoveAssignmentResponse>(
          SeedingServiceRemoveAssignmentResponse.$_createMessage);
  static SeedingServiceRemoveAssignmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class SeedingServiceListAssignmentsRequest extends $pb.GeneratedMessage {
  factory SeedingServiceListAssignmentsRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = SeedingServiceListAssignmentsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  SeedingServiceListAssignmentsRequest._();

  factory SeedingServiceListAssignmentsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListAssignmentsRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceListAssignmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListAssignmentsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceListAssignmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceListAssignmentsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..aI(4, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListAssignmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListAssignmentsRequest copyWith(
          void Function(SeedingServiceListAssignmentsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceListAssignmentsRequest))
          as SeedingServiceListAssignmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceListAssignmentsRequest() / SeedingServiceListAssignmentsRequest.new instead')
  static SeedingServiceListAssignmentsRequest create() =>
      SeedingServiceListAssignmentsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceListAssignmentsRequest._();
  @$core.override
  SeedingServiceListAssignmentsRequest createEmptyInstance() =>
      SeedingServiceListAssignmentsRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceListAssignmentsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceListAssignmentsRequest>(
          SeedingServiceListAssignmentsRequest.$_createMessage);
  static SeedingServiceListAssignmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class SeedingServiceListAssignmentsResponse extends $pb.GeneratedMessage {
  factory SeedingServiceListAssignmentsResponse({
    $core.Iterable<SampleRequest>? assignments,
    $fixnum.Int64? totalCount,
  }) {
    final result = SeedingServiceListAssignmentsResponse._();
    if (assignments != null) result.assignments.addAll(assignments);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  SeedingServiceListAssignmentsResponse._();

  factory SeedingServiceListAssignmentsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListAssignmentsResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceListAssignmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListAssignmentsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceListAssignmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          SeedingServiceListAssignmentsResponse.$_createMessage)
    ..pPM<SampleRequest>(1, _omitFieldNames ? '' : 'assignments',
        subBuilder: SampleRequest.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListAssignmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListAssignmentsResponse copyWith(
          void Function(SeedingServiceListAssignmentsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceListAssignmentsResponse))
          as SeedingServiceListAssignmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceListAssignmentsResponse() / SeedingServiceListAssignmentsResponse.new instead')
  static SeedingServiceListAssignmentsResponse create() =>
      SeedingServiceListAssignmentsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceListAssignmentsResponse._();
  @$core.override
  SeedingServiceListAssignmentsResponse createEmptyInstance() =>
      SeedingServiceListAssignmentsResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceListAssignmentsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceListAssignmentsResponse>(
          SeedingServiceListAssignmentsResponse.$_createMessage);
  static SeedingServiceListAssignmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SampleRequest> get assignments => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalCount => $_getI64(1);
  @$pb.TagNumber(2)
  set totalCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class SeedingServiceListRequestsRequest extends $pb.GeneratedMessage {
  factory SeedingServiceListRequestsRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    SampleRequestStatus? status,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = SeedingServiceListRequestsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (status != null) result.status = status;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  SeedingServiceListRequestsRequest._();

  factory SeedingServiceListRequestsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListRequestsRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceListRequestsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListRequestsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceListRequestsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceListRequestsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aE<SampleRequestStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: SampleRequestStatus.values)
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..aI(5, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListRequestsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListRequestsRequest copyWith(
          void Function(SeedingServiceListRequestsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceListRequestsRequest))
          as SeedingServiceListRequestsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceListRequestsRequest() / SeedingServiceListRequestsRequest.new instead')
  static SeedingServiceListRequestsRequest create() =>
      SeedingServiceListRequestsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceListRequestsRequest._();
  @$core.override
  SeedingServiceListRequestsRequest createEmptyInstance() =>
      SeedingServiceListRequestsRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceListRequestsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceListRequestsRequest>(
          SeedingServiceListRequestsRequest.$_createMessage);
  static SeedingServiceListRequestsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  SampleRequestStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(SampleRequestStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get limit => $_getIZ(3);
  @$pb.TagNumber(4)
  set limit($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get offset => $_getIZ(4);
  @$pb.TagNumber(5)
  set offset($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOffset() => $_has(4);
  @$pb.TagNumber(5)
  void clearOffset() => $_clearField(5);
}

class SeedingServiceListRequestsResponse extends $pb.GeneratedMessage {
  factory SeedingServiceListRequestsResponse({
    $core.Iterable<SampleRequest>? sampleRequests,
    $fixnum.Int64? totalCount,
  }) {
    final result = SeedingServiceListRequestsResponse._();
    if (sampleRequests != null) result.sampleRequests.addAll(sampleRequests);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  SeedingServiceListRequestsResponse._();

  factory SeedingServiceListRequestsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListRequestsResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceListRequestsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceListRequestsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceListRequestsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceListRequestsResponse.$_createMessage)
    ..pPM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequests',
        subBuilder: SampleRequest.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListRequestsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceListRequestsResponse copyWith(
          void Function(SeedingServiceListRequestsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceListRequestsResponse))
          as SeedingServiceListRequestsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceListRequestsResponse() / SeedingServiceListRequestsResponse.new instead')
  static SeedingServiceListRequestsResponse create() =>
      SeedingServiceListRequestsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceListRequestsResponse._();
  @$core.override
  SeedingServiceListRequestsResponse createEmptyInstance() =>
      SeedingServiceListRequestsResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceListRequestsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceListRequestsResponse>(
          SeedingServiceListRequestsResponse.$_createMessage);
  static SeedingServiceListRequestsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SampleRequest> get sampleRequests => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalCount => $_getI64(1);
  @$pb.TagNumber(2)
  set totalCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class SeedingServiceMarkReceivedRequest extends $pb.GeneratedMessage {
  factory SeedingServiceMarkReceivedRequest({
    $core.String? workspaceId,
    $core.String? requestId,
  }) {
    final result = SeedingServiceMarkReceivedRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  SeedingServiceMarkReceivedRequest._();

  factory SeedingServiceMarkReceivedRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceMarkReceivedRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceMarkReceivedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceMarkReceivedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceMarkReceivedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceMarkReceivedRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceMarkReceivedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceMarkReceivedRequest copyWith(
          void Function(SeedingServiceMarkReceivedRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceMarkReceivedRequest))
          as SeedingServiceMarkReceivedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceMarkReceivedRequest() / SeedingServiceMarkReceivedRequest.new instead')
  static SeedingServiceMarkReceivedRequest create() =>
      SeedingServiceMarkReceivedRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceMarkReceivedRequest._();
  @$core.override
  SeedingServiceMarkReceivedRequest createEmptyInstance() =>
      SeedingServiceMarkReceivedRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceMarkReceivedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceMarkReceivedRequest>(
          SeedingServiceMarkReceivedRequest.$_createMessage);
  static SeedingServiceMarkReceivedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);
}

class SeedingServiceMarkReceivedResponse extends $pb.GeneratedMessage {
  factory SeedingServiceMarkReceivedResponse({
    SampleRequest? sampleRequest,
    SampleShipment? shipment,
  }) {
    final result = SeedingServiceMarkReceivedResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    if (shipment != null) result.shipment = shipment;
    return result;
  }

  SeedingServiceMarkReceivedResponse._();

  factory SeedingServiceMarkReceivedResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceMarkReceivedResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceMarkReceivedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceMarkReceivedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceMarkReceivedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceMarkReceivedResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..aOM<SampleShipment>(2, _omitFieldNames ? '' : 'shipment',
        subBuilder: SampleShipment.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceMarkReceivedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceMarkReceivedResponse copyWith(
          void Function(SeedingServiceMarkReceivedResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceMarkReceivedResponse))
          as SeedingServiceMarkReceivedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceMarkReceivedResponse() / SeedingServiceMarkReceivedResponse.new instead')
  static SeedingServiceMarkReceivedResponse create() =>
      SeedingServiceMarkReceivedResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceMarkReceivedResponse._();
  @$core.override
  SeedingServiceMarkReceivedResponse createEmptyInstance() =>
      SeedingServiceMarkReceivedResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceMarkReceivedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceMarkReceivedResponse>(
          SeedingServiceMarkReceivedResponse.$_createMessage);
  static SeedingServiceMarkReceivedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  SampleShipment get shipment => $_getN(1);
  @$pb.TagNumber(2)
  set shipment(SampleShipment value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasShipment() => $_has(1);
  @$pb.TagNumber(2)
  void clearShipment() => $_clearField(2);
  @$pb.TagNumber(2)
  SampleShipment ensureShipment() => $_ensure(1);
}

class SeedingServiceMarkShippedRequest extends $pb.GeneratedMessage {
  factory SeedingServiceMarkShippedRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? requestId,
    $core.String? carrier,
    $core.String? trackingNumber,
    $core.String? shippingCost,
  }) {
    final result = SeedingServiceMarkShippedRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (carrier != null) result.carrier = carrier;
    if (trackingNumber != null) result.trackingNumber = trackingNumber;
    if (shippingCost != null) result.shippingCost = shippingCost;
    return result;
  }

  SeedingServiceMarkShippedRequest._();

  factory SeedingServiceMarkShippedRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceMarkShippedRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceMarkShippedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceMarkShippedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceMarkShippedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceMarkShippedRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'requestId')
    ..aOS(4, _omitFieldNames ? '' : 'carrier')
    ..aOS(5, _omitFieldNames ? '' : 'trackingNumber')
    ..aOS(6, _omitFieldNames ? '' : 'shippingCost')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceMarkShippedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceMarkShippedRequest copyWith(
          void Function(SeedingServiceMarkShippedRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceMarkShippedRequest))
          as SeedingServiceMarkShippedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceMarkShippedRequest() / SeedingServiceMarkShippedRequest.new instead')
  static SeedingServiceMarkShippedRequest create() =>
      SeedingServiceMarkShippedRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceMarkShippedRequest._();
  @$core.override
  SeedingServiceMarkShippedRequest createEmptyInstance() =>
      SeedingServiceMarkShippedRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceMarkShippedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceMarkShippedRequest>(
          SeedingServiceMarkShippedRequest.$_createMessage);
  static SeedingServiceMarkShippedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get carrier => $_getSZ(3);
  @$pb.TagNumber(4)
  set carrier($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCarrier() => $_has(3);
  @$pb.TagNumber(4)
  void clearCarrier() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get trackingNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set trackingNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTrackingNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrackingNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get shippingCost => $_getSZ(5);
  @$pb.TagNumber(6)
  set shippingCost($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShippingCost() => $_has(5);
  @$pb.TagNumber(6)
  void clearShippingCost() => $_clearField(6);
}

class SeedingServiceMarkShippedResponse extends $pb.GeneratedMessage {
  factory SeedingServiceMarkShippedResponse({
    SampleRequest? sampleRequest,
    SampleShipment? shipment,
  }) {
    final result = SeedingServiceMarkShippedResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    if (shipment != null) result.shipment = shipment;
    return result;
  }

  SeedingServiceMarkShippedResponse._();

  factory SeedingServiceMarkShippedResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceMarkShippedResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceMarkShippedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceMarkShippedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceMarkShippedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceMarkShippedResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..aOM<SampleShipment>(2, _omitFieldNames ? '' : 'shipment',
        subBuilder: SampleShipment.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceMarkShippedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceMarkShippedResponse copyWith(
          void Function(SeedingServiceMarkShippedResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceMarkShippedResponse))
          as SeedingServiceMarkShippedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceMarkShippedResponse() / SeedingServiceMarkShippedResponse.new instead')
  static SeedingServiceMarkShippedResponse create() =>
      SeedingServiceMarkShippedResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceMarkShippedResponse._();
  @$core.override
  SeedingServiceMarkShippedResponse createEmptyInstance() =>
      SeedingServiceMarkShippedResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceMarkShippedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceMarkShippedResponse>(
          SeedingServiceMarkShippedResponse.$_createMessage);
  static SeedingServiceMarkShippedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  SampleShipment get shipment => $_getN(1);
  @$pb.TagNumber(2)
  set shipment(SampleShipment value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasShipment() => $_has(1);
  @$pb.TagNumber(2)
  void clearShipment() => $_clearField(2);
  @$pb.TagNumber(2)
  SampleShipment ensureShipment() => $_ensure(1);
}

class SeedingServiceSendReminderRequest extends $pb.GeneratedMessage {
  factory SeedingServiceSendReminderRequest({
    $core.String? workspaceId,
    $core.String? requestId,
    $core.String? message,
  }) {
    final result = SeedingServiceSendReminderRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (message != null) result.message = message;
    return result;
  }

  SeedingServiceSendReminderRequest._();

  factory SeedingServiceSendReminderRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceSendReminderRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceSendReminderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceSendReminderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceSendReminderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceSendReminderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceSendReminderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceSendReminderRequest copyWith(
          void Function(SeedingServiceSendReminderRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceSendReminderRequest))
          as SeedingServiceSendReminderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceSendReminderRequest() / SeedingServiceSendReminderRequest.new instead')
  static SeedingServiceSendReminderRequest create() =>
      SeedingServiceSendReminderRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceSendReminderRequest._();
  @$core.override
  SeedingServiceSendReminderRequest createEmptyInstance() =>
      SeedingServiceSendReminderRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceSendReminderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceSendReminderRequest>(
          SeedingServiceSendReminderRequest.$_createMessage);
  static SeedingServiceSendReminderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class SeedingServiceSendReminderResponse extends $pb.GeneratedMessage {
  factory SeedingServiceSendReminderResponse({
    $core.String? requestId,
    FollowUpStatus? followUpStatus,
    $1.Timestamp? reminderSentAt,
  }) {
    final result = SeedingServiceSendReminderResponse._();
    if (requestId != null) result.requestId = requestId;
    if (followUpStatus != null) result.followUpStatus = followUpStatus;
    if (reminderSentAt != null) result.reminderSentAt = reminderSentAt;
    return result;
  }

  SeedingServiceSendReminderResponse._();

  factory SeedingServiceSendReminderResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceSendReminderResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceSendReminderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceSendReminderResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceSendReminderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceSendReminderResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aE<FollowUpStatus>(2, _omitFieldNames ? '' : 'followUpStatus',
        enumValues: FollowUpStatus.values)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'reminderSentAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceSendReminderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceSendReminderResponse copyWith(
          void Function(SeedingServiceSendReminderResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceSendReminderResponse))
          as SeedingServiceSendReminderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceSendReminderResponse() / SeedingServiceSendReminderResponse.new instead')
  static SeedingServiceSendReminderResponse create() =>
      SeedingServiceSendReminderResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceSendReminderResponse._();
  @$core.override
  SeedingServiceSendReminderResponse createEmptyInstance() =>
      SeedingServiceSendReminderResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceSendReminderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceSendReminderResponse>(
          SeedingServiceSendReminderResponse.$_createMessage);
  static SeedingServiceSendReminderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  FollowUpStatus get followUpStatus => $_getN(1);
  @$pb.TagNumber(2)
  set followUpStatus(FollowUpStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFollowUpStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearFollowUpStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get reminderSentAt => $_getN(2);
  @$pb.TagNumber(3)
  set reminderSentAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReminderSentAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearReminderSentAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureReminderSentAt() => $_ensure(2);
}

class SeedingServiceUpdateStatusRequest extends $pb.GeneratedMessage {
  factory SeedingServiceUpdateStatusRequest({
    $core.String? workspaceId,
    $core.String? requestId,
    SampleRequestStatus? newStatus,
    $core.String? notes,
  }) {
    final result = SeedingServiceUpdateStatusRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (newStatus != null) result.newStatus = newStatus;
    if (notes != null) result.notes = notes;
    return result;
  }

  SeedingServiceUpdateStatusRequest._();

  factory SeedingServiceUpdateStatusRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceUpdateStatusRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceUpdateStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceUpdateStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceUpdateStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceUpdateStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aE<SampleRequestStatus>(3, _omitFieldNames ? '' : 'newStatus',
        enumValues: SampleRequestStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceUpdateStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceUpdateStatusRequest copyWith(
          void Function(SeedingServiceUpdateStatusRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceUpdateStatusRequest))
          as SeedingServiceUpdateStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceUpdateStatusRequest() / SeedingServiceUpdateStatusRequest.new instead')
  static SeedingServiceUpdateStatusRequest create() =>
      SeedingServiceUpdateStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceUpdateStatusRequest._();
  @$core.override
  SeedingServiceUpdateStatusRequest createEmptyInstance() =>
      SeedingServiceUpdateStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceUpdateStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceUpdateStatusRequest>(
          SeedingServiceUpdateStatusRequest.$_createMessage);
  static SeedingServiceUpdateStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  SampleRequestStatus get newStatus => $_getN(2);
  @$pb.TagNumber(3)
  set newStatus(SampleRequestStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);
}

class SeedingServiceUpdateStatusResponse extends $pb.GeneratedMessage {
  factory SeedingServiceUpdateStatusResponse({
    SampleRequest? sampleRequest,
  }) {
    final result = SeedingServiceUpdateStatusResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SeedingServiceUpdateStatusResponse._();

  factory SeedingServiceUpdateStatusResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceUpdateStatusResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceUpdateStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceUpdateStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceUpdateStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceUpdateStatusResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceUpdateStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceUpdateStatusResponse copyWith(
          void Function(SeedingServiceUpdateStatusResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceUpdateStatusResponse))
          as SeedingServiceUpdateStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceUpdateStatusResponse() / SeedingServiceUpdateStatusResponse.new instead')
  static SeedingServiceUpdateStatusResponse create() =>
      SeedingServiceUpdateStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceUpdateStatusResponse._();
  @$core.override
  SeedingServiceUpdateStatusResponse createEmptyInstance() =>
      SeedingServiceUpdateStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceUpdateStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceUpdateStatusResponse>(
          SeedingServiceUpdateStatusResponse.$_createMessage);
  static SeedingServiceUpdateStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);
}

class SeedingServiceDuplicateRequest extends $pb.GeneratedMessage {
  factory SeedingServiceDuplicateRequest({
    $core.String? workspaceId,
    $core.String? requestId,
  }) {
    final result = SeedingServiceDuplicateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  SeedingServiceDuplicateRequest._();

  factory SeedingServiceDuplicateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceDuplicateRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceDuplicateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceDuplicateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceDuplicateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceDuplicateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceDuplicateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceDuplicateRequest copyWith(
          void Function(SeedingServiceDuplicateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceDuplicateRequest))
          as SeedingServiceDuplicateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceDuplicateRequest() / SeedingServiceDuplicateRequest.new instead')
  static SeedingServiceDuplicateRequest create() =>
      SeedingServiceDuplicateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceDuplicateRequest._();
  @$core.override
  SeedingServiceDuplicateRequest createEmptyInstance() =>
      SeedingServiceDuplicateRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceDuplicateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceDuplicateRequest>(
          SeedingServiceDuplicateRequest.$_createMessage);
  static SeedingServiceDuplicateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);
}

class SeedingServiceDuplicateResponse extends $pb.GeneratedMessage {
  factory SeedingServiceDuplicateResponse({
    SampleRequest? newRequest,
  }) {
    final result = SeedingServiceDuplicateResponse._();
    if (newRequest != null) result.newRequest = newRequest;
    return result;
  }

  SeedingServiceDuplicateResponse._();

  factory SeedingServiceDuplicateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceDuplicateResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceDuplicateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceDuplicateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceDuplicateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceDuplicateResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'newRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceDuplicateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceDuplicateResponse copyWith(
          void Function(SeedingServiceDuplicateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceDuplicateResponse))
          as SeedingServiceDuplicateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceDuplicateResponse() / SeedingServiceDuplicateResponse.new instead')
  static SeedingServiceDuplicateResponse create() =>
      SeedingServiceDuplicateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceDuplicateResponse._();
  @$core.override
  SeedingServiceDuplicateResponse createEmptyInstance() =>
      SeedingServiceDuplicateResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceDuplicateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceDuplicateResponse>(
          SeedingServiceDuplicateResponse.$_createMessage);
  static SeedingServiceDuplicateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get newRequest => $_getN(0);
  @$pb.TagNumber(1)
  set newRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNewRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearNewRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureNewRequest() => $_ensure(0);
}

class SeedingServiceDuplicateCampaignRequest extends $pb.GeneratedMessage {
  factory SeedingServiceDuplicateCampaignRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = SeedingServiceDuplicateCampaignRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  SeedingServiceDuplicateCampaignRequest._();

  factory SeedingServiceDuplicateCampaignRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceDuplicateCampaignRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceDuplicateCampaignRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceDuplicateCampaignRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceDuplicateCampaignRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          SeedingServiceDuplicateCampaignRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceDuplicateCampaignRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceDuplicateCampaignRequest copyWith(
          void Function(SeedingServiceDuplicateCampaignRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceDuplicateCampaignRequest))
          as SeedingServiceDuplicateCampaignRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceDuplicateCampaignRequest() / SeedingServiceDuplicateCampaignRequest.new instead')
  static SeedingServiceDuplicateCampaignRequest create() =>
      SeedingServiceDuplicateCampaignRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceDuplicateCampaignRequest._();
  @$core.override
  SeedingServiceDuplicateCampaignRequest createEmptyInstance() =>
      SeedingServiceDuplicateCampaignRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceDuplicateCampaignRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceDuplicateCampaignRequest>(
          SeedingServiceDuplicateCampaignRequest.$_createMessage);
  static SeedingServiceDuplicateCampaignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class SeedingServiceDuplicateCampaignResponse extends $pb.GeneratedMessage {
  factory SeedingServiceDuplicateCampaignResponse({
    SeedingCampaign? newCampaign,
  }) {
    final result = SeedingServiceDuplicateCampaignResponse._();
    if (newCampaign != null) result.newCampaign = newCampaign;
    return result;
  }

  SeedingServiceDuplicateCampaignResponse._();

  factory SeedingServiceDuplicateCampaignResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceDuplicateCampaignResponse()
        ..mergeFromBuffer(data, registry);
  factory SeedingServiceDuplicateCampaignResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceDuplicateCampaignResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceDuplicateCampaignResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          SeedingServiceDuplicateCampaignResponse.$_createMessage)
    ..aOM<SeedingCampaign>(1, _omitFieldNames ? '' : 'newCampaign',
        subBuilder: SeedingCampaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceDuplicateCampaignResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceDuplicateCampaignResponse copyWith(
          void Function(SeedingServiceDuplicateCampaignResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceDuplicateCampaignResponse))
          as SeedingServiceDuplicateCampaignResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceDuplicateCampaignResponse() / SeedingServiceDuplicateCampaignResponse.new instead')
  static SeedingServiceDuplicateCampaignResponse create() =>
      SeedingServiceDuplicateCampaignResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceDuplicateCampaignResponse._();
  @$core.override
  SeedingServiceDuplicateCampaignResponse createEmptyInstance() =>
      SeedingServiceDuplicateCampaignResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceDuplicateCampaignResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SeedingServiceDuplicateCampaignResponse>(
          SeedingServiceDuplicateCampaignResponse.$_createMessage);
  static SeedingServiceDuplicateCampaignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SeedingCampaign get newCampaign => $_getN(0);
  @$pb.TagNumber(1)
  set newCampaign(SeedingCampaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNewCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearNewCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  SeedingCampaign ensureNewCampaign() => $_ensure(0);
}

class SeedingServiceLaunchRequest extends $pb.GeneratedMessage {
  factory SeedingServiceLaunchRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = SeedingServiceLaunchRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  SeedingServiceLaunchRequest._();

  factory SeedingServiceLaunchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceLaunchRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceLaunchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceLaunchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceLaunchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceLaunchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceLaunchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceLaunchRequest copyWith(
          void Function(SeedingServiceLaunchRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceLaunchRequest))
          as SeedingServiceLaunchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceLaunchRequest() / SeedingServiceLaunchRequest.new instead')
  static SeedingServiceLaunchRequest create() =>
      SeedingServiceLaunchRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceLaunchRequest._();
  @$core.override
  SeedingServiceLaunchRequest createEmptyInstance() =>
      SeedingServiceLaunchRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceLaunchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceLaunchRequest>(
          SeedingServiceLaunchRequest.$_createMessage);
  static SeedingServiceLaunchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class SeedingServiceLaunchResponse extends $pb.GeneratedMessage {
  factory SeedingServiceLaunchResponse({
    SeedingCampaign? campaign,
  }) {
    final result = SeedingServiceLaunchResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  SeedingServiceLaunchResponse._();

  factory SeedingServiceLaunchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceLaunchResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceLaunchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceLaunchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceLaunchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceLaunchResponse.$_createMessage)
    ..aOM<SeedingCampaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: SeedingCampaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceLaunchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceLaunchResponse copyWith(
          void Function(SeedingServiceLaunchResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceLaunchResponse))
          as SeedingServiceLaunchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceLaunchResponse() / SeedingServiceLaunchResponse.new instead')
  static SeedingServiceLaunchResponse create() =>
      SeedingServiceLaunchResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceLaunchResponse._();
  @$core.override
  SeedingServiceLaunchResponse createEmptyInstance() =>
      SeedingServiceLaunchResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceLaunchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceLaunchResponse>(
          SeedingServiceLaunchResponse.$_createMessage);
  static SeedingServiceLaunchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SeedingCampaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(SeedingCampaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  SeedingCampaign ensureCampaign() => $_ensure(0);
}

class SeedingServiceLinkContentRequest extends $pb.GeneratedMessage {
  factory SeedingServiceLinkContentRequest({
    $core.String? workspaceId,
    $core.String? requestId,
    $core.String? contentUrl,
    $core.String? contentType,
    $core.String? publishItemId,
    $fixnum.Int64? impressions,
    $fixnum.Int64? views,
    $fixnum.Int64? engagements,
    $fixnum.Int64? conversionsCount,
    $core.String? attributableRevenue,
    $core.String? currency,
    SeedingSourceClass? sourceClass,
    SeedingConfidenceLevel? confidenceLevel,
    $core.String? confidenceReason,
    $core.String? notes,
  }) {
    final result = SeedingServiceLinkContentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (contentUrl != null) result.contentUrl = contentUrl;
    if (contentType != null) result.contentType = contentType;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (impressions != null) result.impressions = impressions;
    if (views != null) result.views = views;
    if (engagements != null) result.engagements = engagements;
    if (conversionsCount != null) result.conversionsCount = conversionsCount;
    if (attributableRevenue != null)
      result.attributableRevenue = attributableRevenue;
    if (currency != null) result.currency = currency;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (confidenceLevel != null) result.confidenceLevel = confidenceLevel;
    if (confidenceReason != null) result.confidenceReason = confidenceReason;
    if (notes != null) result.notes = notes;
    return result;
  }

  SeedingServiceLinkContentRequest._();

  factory SeedingServiceLinkContentRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceLinkContentRequest()..mergeFromBuffer(data, registry);
  factory SeedingServiceLinkContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceLinkContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceLinkContentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceLinkContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aOS(3, _omitFieldNames ? '' : 'contentUrl')
    ..aOS(4, _omitFieldNames ? '' : 'contentType')
    ..aOS(5, _omitFieldNames ? '' : 'publishItemId')
    ..aInt64(6, _omitFieldNames ? '' : 'impressions')
    ..aInt64(7, _omitFieldNames ? '' : 'views')
    ..aInt64(8, _omitFieldNames ? '' : 'engagements')
    ..aInt64(9, _omitFieldNames ? '' : 'conversionsCount')
    ..aOS(10, _omitFieldNames ? '' : 'attributableRevenue')
    ..aOS(11, _omitFieldNames ? '' : 'currency')
    ..aE<SeedingSourceClass>(12, _omitFieldNames ? '' : 'sourceClass',
        enumValues: SeedingSourceClass.values)
    ..aE<SeedingConfidenceLevel>(13, _omitFieldNames ? '' : 'confidenceLevel',
        enumValues: SeedingConfidenceLevel.values)
    ..aOS(14, _omitFieldNames ? '' : 'confidenceReason')
    ..aOS(15, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceLinkContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceLinkContentRequest copyWith(
          void Function(SeedingServiceLinkContentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SeedingServiceLinkContentRequest))
          as SeedingServiceLinkContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceLinkContentRequest() / SeedingServiceLinkContentRequest.new instead')
  static SeedingServiceLinkContentRequest create() =>
      SeedingServiceLinkContentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceLinkContentRequest._();
  @$core.override
  SeedingServiceLinkContentRequest createEmptyInstance() =>
      SeedingServiceLinkContentRequest._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceLinkContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceLinkContentRequest>(
          SeedingServiceLinkContentRequest.$_createMessage);
  static SeedingServiceLinkContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contentUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set contentUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContentUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contentType => $_getSZ(3);
  @$pb.TagNumber(4)
  set contentType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get publishItemId => $_getSZ(4);
  @$pb.TagNumber(5)
  set publishItemId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPublishItemId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublishItemId() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get impressions => $_getI64(5);
  @$pb.TagNumber(6)
  set impressions($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasImpressions() => $_has(5);
  @$pb.TagNumber(6)
  void clearImpressions() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get views => $_getI64(6);
  @$pb.TagNumber(7)
  set views($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasViews() => $_has(6);
  @$pb.TagNumber(7)
  void clearViews() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get engagements => $_getI64(7);
  @$pb.TagNumber(8)
  set engagements($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEngagements() => $_has(7);
  @$pb.TagNumber(8)
  void clearEngagements() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get conversionsCount => $_getI64(8);
  @$pb.TagNumber(9)
  set conversionsCount($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConversionsCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearConversionsCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get attributableRevenue => $_getSZ(9);
  @$pb.TagNumber(10)
  set attributableRevenue($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAttributableRevenue() => $_has(9);
  @$pb.TagNumber(10)
  void clearAttributableRevenue() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get currency => $_getSZ(10);
  @$pb.TagNumber(11)
  set currency($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCurrency() => $_has(10);
  @$pb.TagNumber(11)
  void clearCurrency() => $_clearField(11);

  @$pb.TagNumber(12)
  SeedingSourceClass get sourceClass => $_getN(11);
  @$pb.TagNumber(12)
  set sourceClass(SeedingSourceClass value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSourceClass() => $_has(11);
  @$pb.TagNumber(12)
  void clearSourceClass() => $_clearField(12);

  @$pb.TagNumber(13)
  SeedingConfidenceLevel get confidenceLevel => $_getN(12);
  @$pb.TagNumber(13)
  set confidenceLevel(SeedingConfidenceLevel value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasConfidenceLevel() => $_has(12);
  @$pb.TagNumber(13)
  void clearConfidenceLevel() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get confidenceReason => $_getSZ(13);
  @$pb.TagNumber(14)
  set confidenceReason($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasConfidenceReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearConfidenceReason() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get notes => $_getSZ(14);
  @$pb.TagNumber(15)
  set notes($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasNotes() => $_has(14);
  @$pb.TagNumber(15)
  void clearNotes() => $_clearField(15);
}

class SeedingServiceLinkContentResponse extends $pb.GeneratedMessage {
  factory SeedingServiceLinkContentResponse({
    SampleRequest? sampleRequest,
    SampleOutcome? outcome,
  }) {
    final result = SeedingServiceLinkContentResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    if (outcome != null) result.outcome = outcome;
    return result;
  }

  SeedingServiceLinkContentResponse._();

  factory SeedingServiceLinkContentResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceLinkContentResponse()..mergeFromBuffer(data, registry);
  factory SeedingServiceLinkContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeedingServiceLinkContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeedingServiceLinkContentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SeedingServiceLinkContentResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..aOM<SampleOutcome>(2, _omitFieldNames ? '' : 'outcome',
        subBuilder: SampleOutcome.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceLinkContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeedingServiceLinkContentResponse copyWith(
          void Function(SeedingServiceLinkContentResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SeedingServiceLinkContentResponse))
          as SeedingServiceLinkContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SeedingServiceLinkContentResponse() / SeedingServiceLinkContentResponse.new instead')
  static SeedingServiceLinkContentResponse create() =>
      SeedingServiceLinkContentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SeedingServiceLinkContentResponse._();
  @$core.override
  SeedingServiceLinkContentResponse createEmptyInstance() =>
      SeedingServiceLinkContentResponse._();
  @$core.pragma('dart2js:noInline')
  static SeedingServiceLinkContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeedingServiceLinkContentResponse>(
          SeedingServiceLinkContentResponse.$_createMessage);
  static SeedingServiceLinkContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  SampleOutcome get outcome => $_getN(1);
  @$pb.TagNumber(2)
  set outcome(SampleOutcome value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOutcome() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutcome() => $_clearField(2);
  @$pb.TagNumber(2)
  SampleOutcome ensureOutcome() => $_ensure(1);
}

class SampleServiceCreateRequest extends $pb.GeneratedMessage {
  factory SampleServiceCreateRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? productId,
    $core.String? creatorEntityId,
    $core.int? quantity,
    ShippingAddress? shippingAddress,
    $core.String? contentRequirements,
    $core.String? deadline,
    $core.String? notes,
  }) {
    final result = SampleServiceCreateRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (productId != null) result.productId = productId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (quantity != null) result.quantity = quantity;
    if (shippingAddress != null) result.shippingAddress = shippingAddress;
    if (contentRequirements != null)
      result.contentRequirements = contentRequirements;
    if (deadline != null) result.deadline = deadline;
    if (notes != null) result.notes = notes;
    return result;
  }

  SampleServiceCreateRequest._();

  factory SampleServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'campaignId')
    ..aOS(4, _omitFieldNames ? '' : 'productId')
    ..aOS(5, _omitFieldNames ? '' : 'creatorEntityId')
    ..aI(6, _omitFieldNames ? '' : 'quantity')
    ..aOM<ShippingAddress>(7, _omitFieldNames ? '' : 'shippingAddress',
        subBuilder: ShippingAddress.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'contentRequirements')
    ..aOS(9, _omitFieldNames ? '' : 'deadline')
    ..aOS(10, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceCreateRequest copyWith(
          void Function(SampleServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceCreateRequest))
          as SampleServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceCreateRequest() / SampleServiceCreateRequest.new instead')
  static SampleServiceCreateRequest create() => SampleServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceCreateRequest._();
  @$core.override
  SampleServiceCreateRequest createEmptyInstance() =>
      SampleServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceCreateRequest>(
          SampleServiceCreateRequest.$_createMessage);
  static SampleServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get campaignId => $_getSZ(2);
  @$pb.TagNumber(3)
  set campaignId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCampaignId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCampaignId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productId => $_getSZ(3);
  @$pb.TagNumber(4)
  set productId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creatorEntityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set creatorEntityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatorEntityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatorEntityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get quantity => $_getIZ(5);
  @$pb.TagNumber(6)
  set quantity($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuantity() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuantity() => $_clearField(6);

  @$pb.TagNumber(7)
  ShippingAddress get shippingAddress => $_getN(6);
  @$pb.TagNumber(7)
  set shippingAddress(ShippingAddress value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasShippingAddress() => $_has(6);
  @$pb.TagNumber(7)
  void clearShippingAddress() => $_clearField(7);
  @$pb.TagNumber(7)
  ShippingAddress ensureShippingAddress() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get contentRequirements => $_getSZ(7);
  @$pb.TagNumber(8)
  set contentRequirements($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasContentRequirements() => $_has(7);
  @$pb.TagNumber(8)
  void clearContentRequirements() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get deadline => $_getSZ(8);
  @$pb.TagNumber(9)
  set deadline($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeadline() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeadline() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get notes => $_getSZ(9);
  @$pb.TagNumber(10)
  set notes($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNotes() => $_has(9);
  @$pb.TagNumber(10)
  void clearNotes() => $_clearField(10);
}

class SampleServiceCreateResponse extends $pb.GeneratedMessage {
  factory SampleServiceCreateResponse({
    SampleRequest? sampleRequest,
  }) {
    final result = SampleServiceCreateResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SampleServiceCreateResponse._();

  factory SampleServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceCreateResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceCreateResponse copyWith(
          void Function(SampleServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceCreateResponse))
          as SampleServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceCreateResponse() / SampleServiceCreateResponse.new instead')
  static SampleServiceCreateResponse create() =>
      SampleServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceCreateResponse._();
  @$core.override
  SampleServiceCreateResponse createEmptyInstance() =>
      SampleServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceCreateResponse>(
          SampleServiceCreateResponse.$_createMessage);
  static SampleServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);
}

class SampleServiceListRequest extends $pb.GeneratedMessage {
  factory SampleServiceListRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = SampleServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  SampleServiceListRequest._();

  factory SampleServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceListRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..aI(4, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceListRequest copyWith(
          void Function(SampleServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as SampleServiceListRequest))
          as SampleServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceListRequest() / SampleServiceListRequest.new instead')
  static SampleServiceListRequest create() => SampleServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => SampleServiceListRequest._();
  @$core.override
  SampleServiceListRequest createEmptyInstance() =>
      SampleServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceListRequest>(
          SampleServiceListRequest.$_createMessage);
  static SampleServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class SampleServiceListResponse extends $pb.GeneratedMessage {
  factory SampleServiceListResponse({
    $core.Iterable<SampleRequest>? sampleRequests,
    $fixnum.Int64? totalCount,
  }) {
    final result = SampleServiceListResponse._();
    if (sampleRequests != null) result.sampleRequests.addAll(sampleRequests);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  SampleServiceListResponse._();

  factory SampleServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceListResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceListResponse.$_createMessage)
    ..pPM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequests',
        subBuilder: SampleRequest.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceListResponse copyWith(
          void Function(SampleServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as SampleServiceListResponse))
          as SampleServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceListResponse() / SampleServiceListResponse.new instead')
  static SampleServiceListResponse create() => SampleServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceListResponse._();
  @$core.override
  SampleServiceListResponse createEmptyInstance() =>
      SampleServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceListResponse>(
          SampleServiceListResponse.$_createMessage);
  static SampleServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SampleRequest> get sampleRequests => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalCount => $_getI64(1);
  @$pb.TagNumber(2)
  set totalCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class SampleServiceApproveRequest extends $pb.GeneratedMessage {
  factory SampleServiceApproveRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? requestId,
  }) {
    final result = SampleServiceApproveRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  SampleServiceApproveRequest._();

  factory SampleServiceApproveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceApproveRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceApproveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceApproveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceApproveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceApproveRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceApproveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceApproveRequest copyWith(
          void Function(SampleServiceApproveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceApproveRequest))
          as SampleServiceApproveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceApproveRequest() / SampleServiceApproveRequest.new instead')
  static SampleServiceApproveRequest create() =>
      SampleServiceApproveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceApproveRequest._();
  @$core.override
  SampleServiceApproveRequest createEmptyInstance() =>
      SampleServiceApproveRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceApproveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceApproveRequest>(
          SampleServiceApproveRequest.$_createMessage);
  static SampleServiceApproveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestId() => $_clearField(3);
}

class SampleServiceApproveResponse extends $pb.GeneratedMessage {
  factory SampleServiceApproveResponse({
    SampleRequest? sampleRequest,
  }) {
    final result = SampleServiceApproveResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SampleServiceApproveResponse._();

  factory SampleServiceApproveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceApproveResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceApproveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceApproveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceApproveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceApproveResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceApproveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceApproveResponse copyWith(
          void Function(SampleServiceApproveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceApproveResponse))
          as SampleServiceApproveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceApproveResponse() / SampleServiceApproveResponse.new instead')
  static SampleServiceApproveResponse create() =>
      SampleServiceApproveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceApproveResponse._();
  @$core.override
  SampleServiceApproveResponse createEmptyInstance() =>
      SampleServiceApproveResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceApproveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceApproveResponse>(
          SampleServiceApproveResponse.$_createMessage);
  static SampleServiceApproveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);
}

class SampleServiceDeclineRequest extends $pb.GeneratedMessage {
  factory SampleServiceDeclineRequest({
    $core.String? workspaceId,
    $core.String? requestId,
    $core.String? reason,
  }) {
    final result = SampleServiceDeclineRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (reason != null) result.reason = reason;
    return result;
  }

  SampleServiceDeclineRequest._();

  factory SampleServiceDeclineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceDeclineRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceDeclineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceDeclineRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceDeclineRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceDeclineRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceDeclineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceDeclineRequest copyWith(
          void Function(SampleServiceDeclineRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceDeclineRequest))
          as SampleServiceDeclineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceDeclineRequest() / SampleServiceDeclineRequest.new instead')
  static SampleServiceDeclineRequest create() =>
      SampleServiceDeclineRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceDeclineRequest._();
  @$core.override
  SampleServiceDeclineRequest createEmptyInstance() =>
      SampleServiceDeclineRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceDeclineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceDeclineRequest>(
          SampleServiceDeclineRequest.$_createMessage);
  static SampleServiceDeclineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class SampleServiceDeclineResponse extends $pb.GeneratedMessage {
  factory SampleServiceDeclineResponse({
    SampleRequest? sampleRequest,
  }) {
    final result = SampleServiceDeclineResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SampleServiceDeclineResponse._();

  factory SampleServiceDeclineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceDeclineResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceDeclineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceDeclineResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceDeclineResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceDeclineResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceDeclineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceDeclineResponse copyWith(
          void Function(SampleServiceDeclineResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceDeclineResponse))
          as SampleServiceDeclineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceDeclineResponse() / SampleServiceDeclineResponse.new instead')
  static SampleServiceDeclineResponse create() =>
      SampleServiceDeclineResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceDeclineResponse._();
  @$core.override
  SampleServiceDeclineResponse createEmptyInstance() =>
      SampleServiceDeclineResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceDeclineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceDeclineResponse>(
          SampleServiceDeclineResponse.$_createMessage);
  static SampleServiceDeclineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);
}

class SampleServiceCancelRequest extends $pb.GeneratedMessage {
  factory SampleServiceCancelRequest({
    $core.String? workspaceId,
    $core.String? requestId,
    $core.String? reason,
  }) {
    final result = SampleServiceCancelRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (reason != null) result.reason = reason;
    return result;
  }

  SampleServiceCancelRequest._();

  factory SampleServiceCancelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceCancelRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceCancelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceCancelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceCancelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceCancelRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceCancelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceCancelRequest copyWith(
          void Function(SampleServiceCancelRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceCancelRequest))
          as SampleServiceCancelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceCancelRequest() / SampleServiceCancelRequest.new instead')
  static SampleServiceCancelRequest create() => SampleServiceCancelRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceCancelRequest._();
  @$core.override
  SampleServiceCancelRequest createEmptyInstance() =>
      SampleServiceCancelRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceCancelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceCancelRequest>(
          SampleServiceCancelRequest.$_createMessage);
  static SampleServiceCancelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class SampleServiceCancelResponse extends $pb.GeneratedMessage {
  factory SampleServiceCancelResponse({
    SampleRequest? sampleRequest,
  }) {
    final result = SampleServiceCancelResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SampleServiceCancelResponse._();

  factory SampleServiceCancelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceCancelResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceCancelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceCancelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceCancelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceCancelResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceCancelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceCancelResponse copyWith(
          void Function(SampleServiceCancelResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceCancelResponse))
          as SampleServiceCancelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceCancelResponse() / SampleServiceCancelResponse.new instead')
  static SampleServiceCancelResponse create() =>
      SampleServiceCancelResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceCancelResponse._();
  @$core.override
  SampleServiceCancelResponse createEmptyInstance() =>
      SampleServiceCancelResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceCancelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceCancelResponse>(
          SampleServiceCancelResponse.$_createMessage);
  static SampleServiceCancelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);
}

class SampleServiceMarkShippedRequest extends $pb.GeneratedMessage {
  factory SampleServiceMarkShippedRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? requestId,
    $core.String? carrier,
    $core.String? trackingNumber,
    $core.String? shippingCost,
  }) {
    final result = SampleServiceMarkShippedRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (carrier != null) result.carrier = carrier;
    if (trackingNumber != null) result.trackingNumber = trackingNumber;
    if (shippingCost != null) result.shippingCost = shippingCost;
    return result;
  }

  SampleServiceMarkShippedRequest._();

  factory SampleServiceMarkShippedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceMarkShippedRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceMarkShippedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceMarkShippedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceMarkShippedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceMarkShippedRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'requestId')
    ..aOS(4, _omitFieldNames ? '' : 'carrier')
    ..aOS(5, _omitFieldNames ? '' : 'trackingNumber')
    ..aOS(6, _omitFieldNames ? '' : 'shippingCost')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceMarkShippedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceMarkShippedRequest copyWith(
          void Function(SampleServiceMarkShippedRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceMarkShippedRequest))
          as SampleServiceMarkShippedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceMarkShippedRequest() / SampleServiceMarkShippedRequest.new instead')
  static SampleServiceMarkShippedRequest create() =>
      SampleServiceMarkShippedRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceMarkShippedRequest._();
  @$core.override
  SampleServiceMarkShippedRequest createEmptyInstance() =>
      SampleServiceMarkShippedRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceMarkShippedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceMarkShippedRequest>(
          SampleServiceMarkShippedRequest.$_createMessage);
  static SampleServiceMarkShippedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get carrier => $_getSZ(3);
  @$pb.TagNumber(4)
  set carrier($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCarrier() => $_has(3);
  @$pb.TagNumber(4)
  void clearCarrier() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get trackingNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set trackingNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTrackingNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrackingNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get shippingCost => $_getSZ(5);
  @$pb.TagNumber(6)
  set shippingCost($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShippingCost() => $_has(5);
  @$pb.TagNumber(6)
  void clearShippingCost() => $_clearField(6);
}

class SampleServiceMarkShippedResponse extends $pb.GeneratedMessage {
  factory SampleServiceMarkShippedResponse({
    SampleRequest? sampleRequest,
    SampleShipment? shipment,
  }) {
    final result = SampleServiceMarkShippedResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    if (shipment != null) result.shipment = shipment;
    return result;
  }

  SampleServiceMarkShippedResponse._();

  factory SampleServiceMarkShippedResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceMarkShippedResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceMarkShippedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceMarkShippedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceMarkShippedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceMarkShippedResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..aOM<SampleShipment>(2, _omitFieldNames ? '' : 'shipment',
        subBuilder: SampleShipment.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceMarkShippedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceMarkShippedResponse copyWith(
          void Function(SampleServiceMarkShippedResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceMarkShippedResponse))
          as SampleServiceMarkShippedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceMarkShippedResponse() / SampleServiceMarkShippedResponse.new instead')
  static SampleServiceMarkShippedResponse create() =>
      SampleServiceMarkShippedResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceMarkShippedResponse._();
  @$core.override
  SampleServiceMarkShippedResponse createEmptyInstance() =>
      SampleServiceMarkShippedResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceMarkShippedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceMarkShippedResponse>(
          SampleServiceMarkShippedResponse.$_createMessage);
  static SampleServiceMarkShippedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  SampleShipment get shipment => $_getN(1);
  @$pb.TagNumber(2)
  set shipment(SampleShipment value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasShipment() => $_has(1);
  @$pb.TagNumber(2)
  void clearShipment() => $_clearField(2);
  @$pb.TagNumber(2)
  SampleShipment ensureShipment() => $_ensure(1);
}

class SampleServiceMarkReceivedRequest extends $pb.GeneratedMessage {
  factory SampleServiceMarkReceivedRequest({
    $core.String? workspaceId,
    $core.String? requestId,
  }) {
    final result = SampleServiceMarkReceivedRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  SampleServiceMarkReceivedRequest._();

  factory SampleServiceMarkReceivedRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceMarkReceivedRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceMarkReceivedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceMarkReceivedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceMarkReceivedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceMarkReceivedRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceMarkReceivedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceMarkReceivedRequest copyWith(
          void Function(SampleServiceMarkReceivedRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceMarkReceivedRequest))
          as SampleServiceMarkReceivedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceMarkReceivedRequest() / SampleServiceMarkReceivedRequest.new instead')
  static SampleServiceMarkReceivedRequest create() =>
      SampleServiceMarkReceivedRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceMarkReceivedRequest._();
  @$core.override
  SampleServiceMarkReceivedRequest createEmptyInstance() =>
      SampleServiceMarkReceivedRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceMarkReceivedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceMarkReceivedRequest>(
          SampleServiceMarkReceivedRequest.$_createMessage);
  static SampleServiceMarkReceivedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);
}

class SampleServiceMarkReceivedResponse extends $pb.GeneratedMessage {
  factory SampleServiceMarkReceivedResponse({
    SampleRequest? sampleRequest,
    SampleShipment? shipment,
  }) {
    final result = SampleServiceMarkReceivedResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    if (shipment != null) result.shipment = shipment;
    return result;
  }

  SampleServiceMarkReceivedResponse._();

  factory SampleServiceMarkReceivedResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceMarkReceivedResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceMarkReceivedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceMarkReceivedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceMarkReceivedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceMarkReceivedResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..aOM<SampleShipment>(2, _omitFieldNames ? '' : 'shipment',
        subBuilder: SampleShipment.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceMarkReceivedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceMarkReceivedResponse copyWith(
          void Function(SampleServiceMarkReceivedResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SampleServiceMarkReceivedResponse))
          as SampleServiceMarkReceivedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceMarkReceivedResponse() / SampleServiceMarkReceivedResponse.new instead')
  static SampleServiceMarkReceivedResponse create() =>
      SampleServiceMarkReceivedResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceMarkReceivedResponse._();
  @$core.override
  SampleServiceMarkReceivedResponse createEmptyInstance() =>
      SampleServiceMarkReceivedResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceMarkReceivedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceMarkReceivedResponse>(
          SampleServiceMarkReceivedResponse.$_createMessage);
  static SampleServiceMarkReceivedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  SampleShipment get shipment => $_getN(1);
  @$pb.TagNumber(2)
  set shipment(SampleShipment value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasShipment() => $_has(1);
  @$pb.TagNumber(2)
  void clearShipment() => $_clearField(2);
  @$pb.TagNumber(2)
  SampleShipment ensureShipment() => $_ensure(1);
}

class SampleServiceUpdateStatusRequest extends $pb.GeneratedMessage {
  factory SampleServiceUpdateStatusRequest({
    $core.String? workspaceId,
    $core.String? requestId,
    SampleRequestStatus? newStatus,
    $core.String? notes,
  }) {
    final result = SampleServiceUpdateStatusRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (newStatus != null) result.newStatus = newStatus;
    if (notes != null) result.notes = notes;
    return result;
  }

  SampleServiceUpdateStatusRequest._();

  factory SampleServiceUpdateStatusRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceUpdateStatusRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceUpdateStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceUpdateStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceUpdateStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceUpdateStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aE<SampleRequestStatus>(3, _omitFieldNames ? '' : 'newStatus',
        enumValues: SampleRequestStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceUpdateStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceUpdateStatusRequest copyWith(
          void Function(SampleServiceUpdateStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceUpdateStatusRequest))
          as SampleServiceUpdateStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceUpdateStatusRequest() / SampleServiceUpdateStatusRequest.new instead')
  static SampleServiceUpdateStatusRequest create() =>
      SampleServiceUpdateStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceUpdateStatusRequest._();
  @$core.override
  SampleServiceUpdateStatusRequest createEmptyInstance() =>
      SampleServiceUpdateStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceUpdateStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceUpdateStatusRequest>(
          SampleServiceUpdateStatusRequest.$_createMessage);
  static SampleServiceUpdateStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  SampleRequestStatus get newStatus => $_getN(2);
  @$pb.TagNumber(3)
  set newStatus(SampleRequestStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);
}

class SampleServiceUpdateStatusResponse extends $pb.GeneratedMessage {
  factory SampleServiceUpdateStatusResponse({
    SampleRequest? sampleRequest,
  }) {
    final result = SampleServiceUpdateStatusResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SampleServiceUpdateStatusResponse._();

  factory SampleServiceUpdateStatusResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceUpdateStatusResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceUpdateStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceUpdateStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceUpdateStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceUpdateStatusResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceUpdateStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceUpdateStatusResponse copyWith(
          void Function(SampleServiceUpdateStatusResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SampleServiceUpdateStatusResponse))
          as SampleServiceUpdateStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceUpdateStatusResponse() / SampleServiceUpdateStatusResponse.new instead')
  static SampleServiceUpdateStatusResponse create() =>
      SampleServiceUpdateStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceUpdateStatusResponse._();
  @$core.override
  SampleServiceUpdateStatusResponse createEmptyInstance() =>
      SampleServiceUpdateStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceUpdateStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceUpdateStatusResponse>(
          SampleServiceUpdateStatusResponse.$_createMessage);
  static SampleServiceUpdateStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);
}

class SampleServiceGetSummaryRequest extends $pb.GeneratedMessage {
  factory SampleServiceGetSummaryRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = SampleServiceGetSummaryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  SampleServiceGetSummaryRequest._();

  factory SampleServiceGetSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetSummaryRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceGetSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetSummaryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceGetSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceGetSummaryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetSummaryRequest copyWith(
          void Function(SampleServiceGetSummaryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceGetSummaryRequest))
          as SampleServiceGetSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceGetSummaryRequest() / SampleServiceGetSummaryRequest.new instead')
  static SampleServiceGetSummaryRequest create() =>
      SampleServiceGetSummaryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceGetSummaryRequest._();
  @$core.override
  SampleServiceGetSummaryRequest createEmptyInstance() =>
      SampleServiceGetSummaryRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceGetSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceGetSummaryRequest>(
          SampleServiceGetSummaryRequest.$_createMessage);
  static SampleServiceGetSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class SampleServiceGetSummaryResponse extends $pb.GeneratedMessage {
  factory SampleServiceGetSummaryResponse({
    SeedingReport? report,
  }) {
    final result = SampleServiceGetSummaryResponse._();
    if (report != null) result.report = report;
    return result;
  }

  SampleServiceGetSummaryResponse._();

  factory SampleServiceGetSummaryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetSummaryResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceGetSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetSummaryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceGetSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceGetSummaryResponse.$_createMessage)
    ..aOM<SeedingReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: SeedingReport.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetSummaryResponse copyWith(
          void Function(SampleServiceGetSummaryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceGetSummaryResponse))
          as SampleServiceGetSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceGetSummaryResponse() / SampleServiceGetSummaryResponse.new instead')
  static SampleServiceGetSummaryResponse create() =>
      SampleServiceGetSummaryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceGetSummaryResponse._();
  @$core.override
  SampleServiceGetSummaryResponse createEmptyInstance() =>
      SampleServiceGetSummaryResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceGetSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceGetSummaryResponse>(
          SampleServiceGetSummaryResponse.$_createMessage);
  static SampleServiceGetSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SeedingReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(SeedingReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  SeedingReport ensureReport() => $_ensure(0);
}

class SampleServiceGetStatsRequest extends $pb.GeneratedMessage {
  factory SampleServiceGetStatsRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = SampleServiceGetStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  SampleServiceGetStatsRequest._();

  factory SampleServiceGetStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetStatsRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceGetStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceGetStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceGetStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetStatsRequest copyWith(
          void Function(SampleServiceGetStatsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceGetStatsRequest))
          as SampleServiceGetStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceGetStatsRequest() / SampleServiceGetStatsRequest.new instead')
  static SampleServiceGetStatsRequest create() =>
      SampleServiceGetStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceGetStatsRequest._();
  @$core.override
  SampleServiceGetStatsRequest createEmptyInstance() =>
      SampleServiceGetStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceGetStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceGetStatsRequest>(
          SampleServiceGetStatsRequest.$_createMessage);
  static SampleServiceGetStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class SampleServiceGetStatsResponse extends $pb.GeneratedMessage {
  factory SampleServiceGetStatsResponse({
    $core.int? requestedCount,
    $core.int? approvedCount,
    $core.int? shippedCount,
    $core.int? receivedCount,
    $core.int? reviewPublishedCount,
    $core.int? overdueCount,
    $core.String? totalCost,
    $core.String? reviewRate,
  }) {
    final result = SampleServiceGetStatsResponse._();
    if (requestedCount != null) result.requestedCount = requestedCount;
    if (approvedCount != null) result.approvedCount = approvedCount;
    if (shippedCount != null) result.shippedCount = shippedCount;
    if (receivedCount != null) result.receivedCount = receivedCount;
    if (reviewPublishedCount != null)
      result.reviewPublishedCount = reviewPublishedCount;
    if (overdueCount != null) result.overdueCount = overdueCount;
    if (totalCost != null) result.totalCost = totalCost;
    if (reviewRate != null) result.reviewRate = reviewRate;
    return result;
  }

  SampleServiceGetStatsResponse._();

  factory SampleServiceGetStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetStatsResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceGetStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceGetStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceGetStatsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'requestedCount')
    ..aI(2, _omitFieldNames ? '' : 'approvedCount')
    ..aI(3, _omitFieldNames ? '' : 'shippedCount')
    ..aI(4, _omitFieldNames ? '' : 'receivedCount')
    ..aI(5, _omitFieldNames ? '' : 'reviewPublishedCount')
    ..aI(6, _omitFieldNames ? '' : 'overdueCount')
    ..aOS(7, _omitFieldNames ? '' : 'totalCost')
    ..aOS(8, _omitFieldNames ? '' : 'reviewRate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetStatsResponse copyWith(
          void Function(SampleServiceGetStatsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceGetStatsResponse))
          as SampleServiceGetStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceGetStatsResponse() / SampleServiceGetStatsResponse.new instead')
  static SampleServiceGetStatsResponse create() =>
      SampleServiceGetStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceGetStatsResponse._();
  @$core.override
  SampleServiceGetStatsResponse createEmptyInstance() =>
      SampleServiceGetStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceGetStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceGetStatsResponse>(
          SampleServiceGetStatsResponse.$_createMessage);
  static SampleServiceGetStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requestedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set requestedCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestedCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get approvedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set approvedCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApprovedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearApprovedCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get shippedCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set shippedCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShippedCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearShippedCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get receivedCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set receivedCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReceivedCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceivedCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get reviewPublishedCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set reviewPublishedCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReviewPublishedCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearReviewPublishedCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get overdueCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set overdueCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOverdueCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearOverdueCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get totalCost => $_getSZ(6);
  @$pb.TagNumber(7)
  set totalCost($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalCost() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalCost() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get reviewRate => $_getSZ(7);
  @$pb.TagNumber(8)
  set reviewRate($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReviewRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearReviewRate() => $_clearField(8);
}

class SampleServiceLinkReviewRequest extends $pb.GeneratedMessage {
  factory SampleServiceLinkReviewRequest({
    $core.String? workspaceId,
    $core.String? requestId,
    $core.String? reviewUrl,
    $core.String? platform,
  }) {
    final result = SampleServiceLinkReviewRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (reviewUrl != null) result.reviewUrl = reviewUrl;
    if (platform != null) result.platform = platform;
    return result;
  }

  SampleServiceLinkReviewRequest._();

  factory SampleServiceLinkReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceLinkReviewRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceLinkReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceLinkReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceLinkReviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceLinkReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aOS(3, _omitFieldNames ? '' : 'reviewUrl')
    ..aOS(4, _omitFieldNames ? '' : 'platform')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceLinkReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceLinkReviewRequest copyWith(
          void Function(SampleServiceLinkReviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceLinkReviewRequest))
          as SampleServiceLinkReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceLinkReviewRequest() / SampleServiceLinkReviewRequest.new instead')
  static SampleServiceLinkReviewRequest create() =>
      SampleServiceLinkReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceLinkReviewRequest._();
  @$core.override
  SampleServiceLinkReviewRequest createEmptyInstance() =>
      SampleServiceLinkReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceLinkReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceLinkReviewRequest>(
          SampleServiceLinkReviewRequest.$_createMessage);
  static SampleServiceLinkReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reviewUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set reviewUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReviewUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get platform => $_getSZ(3);
  @$pb.TagNumber(4)
  set platform($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlatform() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatform() => $_clearField(4);
}

class SampleServiceLinkReviewResponse extends $pb.GeneratedMessage {
  factory SampleServiceLinkReviewResponse({
    SampleRequest? sampleRequest,
  }) {
    final result = SampleServiceLinkReviewResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SampleServiceLinkReviewResponse._();

  factory SampleServiceLinkReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceLinkReviewResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceLinkReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceLinkReviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceLinkReviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceLinkReviewResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceLinkReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceLinkReviewResponse copyWith(
          void Function(SampleServiceLinkReviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceLinkReviewResponse))
          as SampleServiceLinkReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceLinkReviewResponse() / SampleServiceLinkReviewResponse.new instead')
  static SampleServiceLinkReviewResponse create() =>
      SampleServiceLinkReviewResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceLinkReviewResponse._();
  @$core.override
  SampleServiceLinkReviewResponse createEmptyInstance() =>
      SampleServiceLinkReviewResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceLinkReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceLinkReviewResponse>(
          SampleServiceLinkReviewResponse.$_createMessage);
  static SampleServiceLinkReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);
}

class SampleServiceRateCreatorRequest extends $pb.GeneratedMessage {
  factory SampleServiceRateCreatorRequest({
    $core.String? workspaceId,
    $core.String? creatorEntityId,
    $core.int? rating,
    $core.String? feedback,
  }) {
    final result = SampleServiceRateCreatorRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (creatorEntityId != null) result.creatorEntityId = creatorEntityId;
    if (rating != null) result.rating = rating;
    if (feedback != null) result.feedback = feedback;
    return result;
  }

  SampleServiceRateCreatorRequest._();

  factory SampleServiceRateCreatorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceRateCreatorRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceRateCreatorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceRateCreatorRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceRateCreatorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceRateCreatorRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'creatorEntityId')
    ..aI(3, _omitFieldNames ? '' : 'rating')
    ..aOS(4, _omitFieldNames ? '' : 'feedback')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceRateCreatorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceRateCreatorRequest copyWith(
          void Function(SampleServiceRateCreatorRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceRateCreatorRequest))
          as SampleServiceRateCreatorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceRateCreatorRequest() / SampleServiceRateCreatorRequest.new instead')
  static SampleServiceRateCreatorRequest create() =>
      SampleServiceRateCreatorRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceRateCreatorRequest._();
  @$core.override
  SampleServiceRateCreatorRequest createEmptyInstance() =>
      SampleServiceRateCreatorRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceRateCreatorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceRateCreatorRequest>(
          SampleServiceRateCreatorRequest.$_createMessage);
  static SampleServiceRateCreatorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get creatorEntityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set creatorEntityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreatorEntityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatorEntityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get rating => $_getIZ(2);
  @$pb.TagNumber(3)
  set rating($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRating() => $_has(2);
  @$pb.TagNumber(3)
  void clearRating() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get feedback => $_getSZ(3);
  @$pb.TagNumber(4)
  set feedback($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFeedback() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeedback() => $_clearField(4);
}

class SampleServiceRateCreatorResponse extends $pb.GeneratedMessage {
  factory SampleServiceRateCreatorResponse({
    $core.bool? success,
  }) {
    final result = SampleServiceRateCreatorResponse._();
    if (success != null) result.success = success;
    return result;
  }

  SampleServiceRateCreatorResponse._();

  factory SampleServiceRateCreatorResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceRateCreatorResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceRateCreatorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceRateCreatorResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceRateCreatorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceRateCreatorResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceRateCreatorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceRateCreatorResponse copyWith(
          void Function(SampleServiceRateCreatorResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceRateCreatorResponse))
          as SampleServiceRateCreatorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceRateCreatorResponse() / SampleServiceRateCreatorResponse.new instead')
  static SampleServiceRateCreatorResponse create() =>
      SampleServiceRateCreatorResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceRateCreatorResponse._();
  @$core.override
  SampleServiceRateCreatorResponse createEmptyInstance() =>
      SampleServiceRateCreatorResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceRateCreatorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceRateCreatorResponse>(
          SampleServiceRateCreatorResponse.$_createMessage);
  static SampleServiceRateCreatorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class SampleServiceGetReviewRevenueRequest extends $pb.GeneratedMessage {
  factory SampleServiceGetReviewRevenueRequest({
    $core.String? workspaceId,
    $core.String? requestId,
  }) {
    final result = SampleServiceGetReviewRevenueRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  SampleServiceGetReviewRevenueRequest._();

  factory SampleServiceGetReviewRevenueRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetReviewRevenueRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceGetReviewRevenueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetReviewRevenueRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceGetReviewRevenueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceGetReviewRevenueRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetReviewRevenueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetReviewRevenueRequest copyWith(
          void Function(SampleServiceGetReviewRevenueRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SampleServiceGetReviewRevenueRequest))
          as SampleServiceGetReviewRevenueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceGetReviewRevenueRequest() / SampleServiceGetReviewRevenueRequest.new instead')
  static SampleServiceGetReviewRevenueRequest create() =>
      SampleServiceGetReviewRevenueRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceGetReviewRevenueRequest._();
  @$core.override
  SampleServiceGetReviewRevenueRequest createEmptyInstance() =>
      SampleServiceGetReviewRevenueRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceGetReviewRevenueRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SampleServiceGetReviewRevenueRequest>(
          SampleServiceGetReviewRevenueRequest.$_createMessage);
  static SampleServiceGetReviewRevenueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);
}

class SampleServiceGetReviewRevenueResponse extends $pb.GeneratedMessage {
  factory SampleServiceGetReviewRevenueResponse({
    $core.String? attributableRevenue,
    $core.String? currency,
    SeedingSourceClass? sourceClass,
  }) {
    final result = SampleServiceGetReviewRevenueResponse._();
    if (attributableRevenue != null)
      result.attributableRevenue = attributableRevenue;
    if (currency != null) result.currency = currency;
    if (sourceClass != null) result.sourceClass = sourceClass;
    return result;
  }

  SampleServiceGetReviewRevenueResponse._();

  factory SampleServiceGetReviewRevenueResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetReviewRevenueResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceGetReviewRevenueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceGetReviewRevenueResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceGetReviewRevenueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          SampleServiceGetReviewRevenueResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'attributableRevenue')
    ..aOS(2, _omitFieldNames ? '' : 'currency')
    ..aE<SeedingSourceClass>(3, _omitFieldNames ? '' : 'sourceClass',
        enumValues: SeedingSourceClass.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetReviewRevenueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceGetReviewRevenueResponse copyWith(
          void Function(SampleServiceGetReviewRevenueResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SampleServiceGetReviewRevenueResponse))
          as SampleServiceGetReviewRevenueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceGetReviewRevenueResponse() / SampleServiceGetReviewRevenueResponse.new instead')
  static SampleServiceGetReviewRevenueResponse create() =>
      SampleServiceGetReviewRevenueResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceGetReviewRevenueResponse._();
  @$core.override
  SampleServiceGetReviewRevenueResponse createEmptyInstance() =>
      SampleServiceGetReviewRevenueResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceGetReviewRevenueResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SampleServiceGetReviewRevenueResponse>(
          SampleServiceGetReviewRevenueResponse.$_createMessage);
  static SampleServiceGetReviewRevenueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get attributableRevenue => $_getSZ(0);
  @$pb.TagNumber(1)
  set attributableRevenue($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAttributableRevenue() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttributableRevenue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);

  @$pb.TagNumber(3)
  SeedingSourceClass get sourceClass => $_getN(2);
  @$pb.TagNumber(3)
  set sourceClass(SeedingSourceClass value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceClass() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceClass() => $_clearField(3);
}

class SampleServiceExtendDeadlineRequest extends $pb.GeneratedMessage {
  factory SampleServiceExtendDeadlineRequest({
    $core.String? workspaceId,
    $core.String? requestId,
    $core.String? newDeadline,
    $core.String? reason,
  }) {
    final result = SampleServiceExtendDeadlineRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (requestId != null) result.requestId = requestId;
    if (newDeadline != null) result.newDeadline = newDeadline;
    if (reason != null) result.reason = reason;
    return result;
  }

  SampleServiceExtendDeadlineRequest._();

  factory SampleServiceExtendDeadlineRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceExtendDeadlineRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceExtendDeadlineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceExtendDeadlineRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceExtendDeadlineRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceExtendDeadlineRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aOS(3, _omitFieldNames ? '' : 'newDeadline')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceExtendDeadlineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceExtendDeadlineRequest copyWith(
          void Function(SampleServiceExtendDeadlineRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SampleServiceExtendDeadlineRequest))
          as SampleServiceExtendDeadlineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceExtendDeadlineRequest() / SampleServiceExtendDeadlineRequest.new instead')
  static SampleServiceExtendDeadlineRequest create() =>
      SampleServiceExtendDeadlineRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceExtendDeadlineRequest._();
  @$core.override
  SampleServiceExtendDeadlineRequest createEmptyInstance() =>
      SampleServiceExtendDeadlineRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceExtendDeadlineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceExtendDeadlineRequest>(
          SampleServiceExtendDeadlineRequest.$_createMessage);
  static SampleServiceExtendDeadlineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newDeadline => $_getSZ(2);
  @$pb.TagNumber(3)
  set newDeadline($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewDeadline() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewDeadline() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class SampleServiceExtendDeadlineResponse extends $pb.GeneratedMessage {
  factory SampleServiceExtendDeadlineResponse({
    SampleRequest? sampleRequest,
  }) {
    final result = SampleServiceExtendDeadlineResponse._();
    if (sampleRequest != null) result.sampleRequest = sampleRequest;
    return result;
  }

  SampleServiceExtendDeadlineResponse._();

  factory SampleServiceExtendDeadlineResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceExtendDeadlineResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceExtendDeadlineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceExtendDeadlineResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceExtendDeadlineResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceExtendDeadlineResponse.$_createMessage)
    ..aOM<SampleRequest>(1, _omitFieldNames ? '' : 'sampleRequest',
        subBuilder: SampleRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceExtendDeadlineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceExtendDeadlineResponse copyWith(
          void Function(SampleServiceExtendDeadlineResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SampleServiceExtendDeadlineResponse))
          as SampleServiceExtendDeadlineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceExtendDeadlineResponse() / SampleServiceExtendDeadlineResponse.new instead')
  static SampleServiceExtendDeadlineResponse create() =>
      SampleServiceExtendDeadlineResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceExtendDeadlineResponse._();
  @$core.override
  SampleServiceExtendDeadlineResponse createEmptyInstance() =>
      SampleServiceExtendDeadlineResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceExtendDeadlineResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SampleServiceExtendDeadlineResponse>(
          SampleServiceExtendDeadlineResponse.$_createMessage);
  static SampleServiceExtendDeadlineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SampleRequest get sampleRequest => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRequest(SampleRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSampleRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  SampleRequest ensureSampleRequest() => $_ensure(0);
}

class SampleServiceExportReportRequest extends $pb.GeneratedMessage {
  factory SampleServiceExportReportRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? format,
  }) {
    final result = SampleServiceExportReportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (format != null) result.format = format;
    return result;
  }

  SampleServiceExportReportRequest._();

  factory SampleServiceExportReportRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceExportReportRequest()..mergeFromBuffer(data, registry);
  factory SampleServiceExportReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceExportReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceExportReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceExportReportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceExportReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceExportReportRequest copyWith(
          void Function(SampleServiceExportReportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SampleServiceExportReportRequest))
          as SampleServiceExportReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceExportReportRequest() / SampleServiceExportReportRequest.new instead')
  static SampleServiceExportReportRequest create() =>
      SampleServiceExportReportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceExportReportRequest._();
  @$core.override
  SampleServiceExportReportRequest createEmptyInstance() =>
      SampleServiceExportReportRequest._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceExportReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceExportReportRequest>(
          SampleServiceExportReportRequest.$_createMessage);
  static SampleServiceExportReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get format => $_getSZ(2);
  @$pb.TagNumber(3)
  set format($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);
}

class SampleServiceExportReportResponse extends $pb.GeneratedMessage {
  factory SampleServiceExportReportResponse({
    $core.String? fileUrl,
    $core.String? content,
  }) {
    final result = SampleServiceExportReportResponse._();
    if (fileUrl != null) result.fileUrl = fileUrl;
    if (content != null) result.content = content;
    return result;
  }

  SampleServiceExportReportResponse._();

  factory SampleServiceExportReportResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceExportReportResponse()..mergeFromBuffer(data, registry);
  factory SampleServiceExportReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SampleServiceExportReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SampleServiceExportReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SampleServiceExportReportResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'fileUrl')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceExportReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SampleServiceExportReportResponse copyWith(
          void Function(SampleServiceExportReportResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SampleServiceExportReportResponse))
          as SampleServiceExportReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SampleServiceExportReportResponse() / SampleServiceExportReportResponse.new instead')
  static SampleServiceExportReportResponse create() =>
      SampleServiceExportReportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SampleServiceExportReportResponse._();
  @$core.override
  SampleServiceExportReportResponse createEmptyInstance() =>
      SampleServiceExportReportResponse._();
  @$core.pragma('dart2js:noInline')
  static SampleServiceExportReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SampleServiceExportReportResponse>(
          SampleServiceExportReportResponse.$_createMessage);
  static SampleServiceExportReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
