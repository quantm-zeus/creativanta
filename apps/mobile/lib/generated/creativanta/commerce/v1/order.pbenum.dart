// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/order.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Source classification taxonomy per PRD §15.1.
class OrderSourceClass extends $pb.ProtobufEnum {
  static const OrderSourceClass ORDER_SOURCE_CLASS_UNSPECIFIED =
      OrderSourceClass._(
          0, _omitEnumNames ? '' : 'ORDER_SOURCE_CLASS_UNSPECIFIED');
  static const OrderSourceClass ORDER_SOURCE_CLASS_OFFICIAL =
      OrderSourceClass._(
          1, _omitEnumNames ? '' : 'ORDER_SOURCE_CLASS_OFFICIAL');
  static const OrderSourceClass ORDER_SOURCE_CLASS_IMPORTED =
      OrderSourceClass._(
          2, _omitEnumNames ? '' : 'ORDER_SOURCE_CLASS_IMPORTED');
  static const OrderSourceClass ORDER_SOURCE_CLASS_INFERRED =
      OrderSourceClass._(
          3, _omitEnumNames ? '' : 'ORDER_SOURCE_CLASS_INFERRED');
  static const OrderSourceClass ORDER_SOURCE_CLASS_ESTIMATED =
      OrderSourceClass._(
          4, _omitEnumNames ? '' : 'ORDER_SOURCE_CLASS_ESTIMATED');
  static const OrderSourceClass ORDER_SOURCE_CLASS_UNRECONCILED =
      OrderSourceClass._(
          5, _omitEnumNames ? '' : 'ORDER_SOURCE_CLASS_UNRECONCILED');

  static const $core.List<OrderSourceClass> values = <OrderSourceClass>[
    ORDER_SOURCE_CLASS_UNSPECIFIED,
    ORDER_SOURCE_CLASS_OFFICIAL,
    ORDER_SOURCE_CLASS_IMPORTED,
    ORDER_SOURCE_CLASS_INFERRED,
    ORDER_SOURCE_CLASS_ESTIMATED,
    ORDER_SOURCE_CLASS_UNRECONCILED,
  ];

  static final $core.List<OrderSourceClass?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static OrderSourceClass? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OrderSourceClass._(super.value, super.name);
}

/// Canonical order lifecycle state machine per RULE-M13-003.
class OrderLifecycleState extends $pb.ProtobufEnum {
  static const OrderLifecycleState ORDER_LIFECYCLE_STATE_UNSPECIFIED =
      OrderLifecycleState._(
          0, _omitEnumNames ? '' : 'ORDER_LIFECYCLE_STATE_UNSPECIFIED');
  static const OrderLifecycleState ORDER_LIFECYCLE_STATE_CREATED =
      OrderLifecycleState._(
          1, _omitEnumNames ? '' : 'ORDER_LIFECYCLE_STATE_CREATED');
  static const OrderLifecycleState ORDER_LIFECYCLE_STATE_CONFIRMED =
      OrderLifecycleState._(
          2, _omitEnumNames ? '' : 'ORDER_LIFECYCLE_STATE_CONFIRMED');
  static const OrderLifecycleState ORDER_LIFECYCLE_STATE_FULFILLED =
      OrderLifecycleState._(
          3, _omitEnumNames ? '' : 'ORDER_LIFECYCLE_STATE_FULFILLED');
  static const OrderLifecycleState ORDER_LIFECYCLE_STATE_COMPLETED =
      OrderLifecycleState._(
          4, _omitEnumNames ? '' : 'ORDER_LIFECYCLE_STATE_COMPLETED');
  static const OrderLifecycleState ORDER_LIFECYCLE_STATE_REFUNDED =
      OrderLifecycleState._(
          5, _omitEnumNames ? '' : 'ORDER_LIFECYCLE_STATE_REFUNDED');
  static const OrderLifecycleState ORDER_LIFECYCLE_STATE_PARTIALLY_REFUNDED =
      OrderLifecycleState._(
          6, _omitEnumNames ? '' : 'ORDER_LIFECYCLE_STATE_PARTIALLY_REFUNDED');
  static const OrderLifecycleState ORDER_LIFECYCLE_STATE_RETURNED =
      OrderLifecycleState._(
          7, _omitEnumNames ? '' : 'ORDER_LIFECYCLE_STATE_RETURNED');
  static const OrderLifecycleState ORDER_LIFECYCLE_STATE_CANCELLED =
      OrderLifecycleState._(
          8, _omitEnumNames ? '' : 'ORDER_LIFECYCLE_STATE_CANCELLED');

  static const $core.List<OrderLifecycleState> values = <OrderLifecycleState>[
    ORDER_LIFECYCLE_STATE_UNSPECIFIED,
    ORDER_LIFECYCLE_STATE_CREATED,
    ORDER_LIFECYCLE_STATE_CONFIRMED,
    ORDER_LIFECYCLE_STATE_FULFILLED,
    ORDER_LIFECYCLE_STATE_COMPLETED,
    ORDER_LIFECYCLE_STATE_REFUNDED,
    ORDER_LIFECYCLE_STATE_PARTIALLY_REFUNDED,
    ORDER_LIFECYCLE_STATE_RETURNED,
    ORDER_LIFECYCLE_STATE_CANCELLED,
  ];

  static final $core.List<OrderLifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static OrderLifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OrderLifecycleState._(super.value, super.name);
}

/// Refund lifecycle state machine per Freeze §27.2.
class RefundLifecycleState extends $pb.ProtobufEnum {
  static const RefundLifecycleState REFUND_LIFECYCLE_STATE_UNSPECIFIED =
      RefundLifecycleState._(
          0, _omitEnumNames ? '' : 'REFUND_LIFECYCLE_STATE_UNSPECIFIED');
  static const RefundLifecycleState REFUND_LIFECYCLE_STATE_REQUESTED =
      RefundLifecycleState._(
          1, _omitEnumNames ? '' : 'REFUND_LIFECYCLE_STATE_REQUESTED');
  static const RefundLifecycleState REFUND_LIFECYCLE_STATE_APPROVED =
      RefundLifecycleState._(
          2, _omitEnumNames ? '' : 'REFUND_LIFECYCLE_STATE_APPROVED');
  static const RefundLifecycleState REFUND_LIFECYCLE_STATE_REJECTED =
      RefundLifecycleState._(
          3, _omitEnumNames ? '' : 'REFUND_LIFECYCLE_STATE_REJECTED');
  static const RefundLifecycleState REFUND_LIFECYCLE_STATE_PROCESSING =
      RefundLifecycleState._(
          4, _omitEnumNames ? '' : 'REFUND_LIFECYCLE_STATE_PROCESSING');
  static const RefundLifecycleState REFUND_LIFECYCLE_STATE_COMPLETED =
      RefundLifecycleState._(
          5, _omitEnumNames ? '' : 'REFUND_LIFECYCLE_STATE_COMPLETED');
  static const RefundLifecycleState REFUND_LIFECYCLE_STATE_FAILED =
      RefundLifecycleState._(
          6, _omitEnumNames ? '' : 'REFUND_LIFECYCLE_STATE_FAILED');
  static const RefundLifecycleState REFUND_LIFECYCLE_STATE_CANCELLED =
      RefundLifecycleState._(
          7, _omitEnumNames ? '' : 'REFUND_LIFECYCLE_STATE_CANCELLED');

  static const $core.List<RefundLifecycleState> values = <RefundLifecycleState>[
    REFUND_LIFECYCLE_STATE_UNSPECIFIED,
    REFUND_LIFECYCLE_STATE_REQUESTED,
    REFUND_LIFECYCLE_STATE_APPROVED,
    REFUND_LIFECYCLE_STATE_REJECTED,
    REFUND_LIFECYCLE_STATE_PROCESSING,
    REFUND_LIFECYCLE_STATE_COMPLETED,
    REFUND_LIFECYCLE_STATE_FAILED,
    REFUND_LIFECYCLE_STATE_CANCELLED,
  ];

  static final $core.List<RefundLifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static RefundLifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RefundLifecycleState._(super.value, super.name);
}

/// Return lifecycle state machine per DB Schema §19.6.
class ReturnLifecycleState extends $pb.ProtobufEnum {
  static const ReturnLifecycleState RETURN_LIFECYCLE_STATE_UNSPECIFIED =
      ReturnLifecycleState._(
          0, _omitEnumNames ? '' : 'RETURN_LIFECYCLE_STATE_UNSPECIFIED');
  static const ReturnLifecycleState RETURN_LIFECYCLE_STATE_INITIATED =
      ReturnLifecycleState._(
          1, _omitEnumNames ? '' : 'RETURN_LIFECYCLE_STATE_INITIATED');
  static const ReturnLifecycleState RETURN_LIFECYCLE_STATE_APPROVED =
      ReturnLifecycleState._(
          2, _omitEnumNames ? '' : 'RETURN_LIFECYCLE_STATE_APPROVED');
  static const ReturnLifecycleState RETURN_LIFECYCLE_STATE_SHIPPED_BACK =
      ReturnLifecycleState._(
          3, _omitEnumNames ? '' : 'RETURN_LIFECYCLE_STATE_SHIPPED_BACK');
  static const ReturnLifecycleState RETURN_LIFECYCLE_STATE_RECEIVED =
      ReturnLifecycleState._(
          4, _omitEnumNames ? '' : 'RETURN_LIFECYCLE_STATE_RECEIVED');
  static const ReturnLifecycleState RETURN_LIFECYCLE_STATE_INSPECTED =
      ReturnLifecycleState._(
          5, _omitEnumNames ? '' : 'RETURN_LIFECYCLE_STATE_INSPECTED');
  static const ReturnLifecycleState RETURN_LIFECYCLE_STATE_CLOSED =
      ReturnLifecycleState._(
          6, _omitEnumNames ? '' : 'RETURN_LIFECYCLE_STATE_CLOSED');
  static const ReturnLifecycleState RETURN_LIFECYCLE_STATE_REJECTED =
      ReturnLifecycleState._(
          7, _omitEnumNames ? '' : 'RETURN_LIFECYCLE_STATE_REJECTED');

  static const $core.List<ReturnLifecycleState> values = <ReturnLifecycleState>[
    RETURN_LIFECYCLE_STATE_UNSPECIFIED,
    RETURN_LIFECYCLE_STATE_INITIATED,
    RETURN_LIFECYCLE_STATE_APPROVED,
    RETURN_LIFECYCLE_STATE_SHIPPED_BACK,
    RETURN_LIFECYCLE_STATE_RECEIVED,
    RETURN_LIFECYCLE_STATE_INSPECTED,
    RETURN_LIFECYCLE_STATE_CLOSED,
    RETURN_LIFECYCLE_STATE_REJECTED,
  ];

  static final $core.List<ReturnLifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static ReturnLifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReturnLifecycleState._(super.value, super.name);
}

/// Immutable stock movement types per DB Schema §19.9H.
class StockMovementType extends $pb.ProtobufEnum {
  static const StockMovementType STOCK_MOVEMENT_TYPE_UNSPECIFIED =
      StockMovementType._(
          0, _omitEnumNames ? '' : 'STOCK_MOVEMENT_TYPE_UNSPECIFIED');
  static const StockMovementType STOCK_MOVEMENT_TYPE_PURCHASE =
      StockMovementType._(
          1, _omitEnumNames ? '' : 'STOCK_MOVEMENT_TYPE_PURCHASE');
  static const StockMovementType STOCK_MOVEMENT_TYPE_SALE =
      StockMovementType._(2, _omitEnumNames ? '' : 'STOCK_MOVEMENT_TYPE_SALE');
  static const StockMovementType STOCK_MOVEMENT_TYPE_RETURN =
      StockMovementType._(
          3, _omitEnumNames ? '' : 'STOCK_MOVEMENT_TYPE_RETURN');
  static const StockMovementType STOCK_MOVEMENT_TYPE_ADJUSTMENT =
      StockMovementType._(
          4, _omitEnumNames ? '' : 'STOCK_MOVEMENT_TYPE_ADJUSTMENT');
  static const StockMovementType STOCK_MOVEMENT_TYPE_TRANSFER =
      StockMovementType._(
          5, _omitEnumNames ? '' : 'STOCK_MOVEMENT_TYPE_TRANSFER');
  static const StockMovementType STOCK_MOVEMENT_TYPE_DAMAGE =
      StockMovementType._(
          6, _omitEnumNames ? '' : 'STOCK_MOVEMENT_TYPE_DAMAGE');
  static const StockMovementType STOCK_MOVEMENT_TYPE_PLATFORM_SYNC =
      StockMovementType._(
          7, _omitEnumNames ? '' : 'STOCK_MOVEMENT_TYPE_PLATFORM_SYNC');

  static const $core.List<StockMovementType> values = <StockMovementType>[
    STOCK_MOVEMENT_TYPE_UNSPECIFIED,
    STOCK_MOVEMENT_TYPE_PURCHASE,
    STOCK_MOVEMENT_TYPE_SALE,
    STOCK_MOVEMENT_TYPE_RETURN,
    STOCK_MOVEMENT_TYPE_ADJUSTMENT,
    STOCK_MOVEMENT_TYPE_TRANSFER,
    STOCK_MOVEMENT_TYPE_DAMAGE,
    STOCK_MOVEMENT_TYPE_PLATFORM_SYNC,
  ];

  static final $core.List<StockMovementType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static StockMovementType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StockMovementType._(super.value, super.name);
}

/// Reservation lifecycle states per DB Schema §26.12.
class StockReservationStatus extends $pb.ProtobufEnum {
  static const StockReservationStatus STOCK_RESERVATION_STATUS_UNSPECIFIED =
      StockReservationStatus._(
          0, _omitEnumNames ? '' : 'STOCK_RESERVATION_STATUS_UNSPECIFIED');
  static const StockReservationStatus STOCK_RESERVATION_STATUS_HELD =
      StockReservationStatus._(
          1, _omitEnumNames ? '' : 'STOCK_RESERVATION_STATUS_HELD');
  static const StockReservationStatus STOCK_RESERVATION_STATUS_CONSUMED =
      StockReservationStatus._(
          2, _omitEnumNames ? '' : 'STOCK_RESERVATION_STATUS_CONSUMED');
  static const StockReservationStatus STOCK_RESERVATION_STATUS_RELEASED =
      StockReservationStatus._(
          3, _omitEnumNames ? '' : 'STOCK_RESERVATION_STATUS_RELEASED');
  static const StockReservationStatus STOCK_RESERVATION_STATUS_EXPIRED =
      StockReservationStatus._(
          4, _omitEnumNames ? '' : 'STOCK_RESERVATION_STATUS_EXPIRED');

  static const $core.List<StockReservationStatus> values =
      <StockReservationStatus>[
    STOCK_RESERVATION_STATUS_UNSPECIFIED,
    STOCK_RESERVATION_STATUS_HELD,
    STOCK_RESERVATION_STATUS_CONSUMED,
    STOCK_RESERVATION_STATUS_RELEASED,
    STOCK_RESERVATION_STATUS_EXPIRED,
  ];

  static final $core.List<StockReservationStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static StockReservationStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StockReservationStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
