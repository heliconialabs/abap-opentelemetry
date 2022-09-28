CLASS zcl_otlp_protobuf_stream DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ty_wire_type TYPE i .
    TYPES:
      BEGIN OF ty_field_and_type,
        field_number TYPE i,
        wire_type    TYPE ty_wire_type,
      END OF ty_field_and_type .

    CONSTANTS:
      BEGIN OF gc_wire_type,
        varint           TYPE ty_wire_type VALUE 0,
        bit64            TYPE ty_wire_type VALUE 1,
        length_delimited TYPE ty_wire_type VALUE 2,
        start_group      TYPE ty_wire_type VALUE 3,
        end_group        TYPE ty_wire_type VALUE 4,
        bit32            TYPE ty_wire_type VALUE 5,
      END OF gc_wire_type .

    METHODS constructor
      IMPORTING
        !iv_hex TYPE xstring OPTIONAL .
    METHODS encode_delimited
      IMPORTING
        !iv_hex       TYPE xstring
      RETURNING
        VALUE(ro_ref) TYPE REF TO zcl_otlp_protobuf_stream .
    METHODS encode_double
      IMPORTING
        !iv_double    TYPE f
      RETURNING
        VALUE(ro_ref) TYPE REF TO zcl_otlp_protobuf_stream .
    METHODS encode_field_and_type
      IMPORTING
        !is_field_and_type TYPE ty_field_and_type
      RETURNING
        VALUE(ro_ref)      TYPE REF TO zcl_otlp_protobuf_stream .
    METHODS encode_fixed64
      IMPORTING
        !iv_int       TYPE int8
      RETURNING
        VALUE(ro_ref) TYPE REF TO zcl_otlp_protobuf_stream .
    METHODS encode_varint
      IMPORTING
        !iv_int       TYPE i
      RETURNING
        VALUE(ro_ref) TYPE REF TO zcl_otlp_protobuf_stream .
    METHODS encode_bool
      IMPORTING
        !iv_bool      TYPE abap_bool
      RETURNING
        VALUE(ro_ref) TYPE REF TO zcl_otlp_protobuf_stream .
    METHODS get
      RETURNING
        VALUE(rv_hex) TYPE xstring .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_hex TYPE xstring .

    METHODS append
      IMPORTING
        !iv_hex TYPE xsequence .
ENDCLASS.



CLASS ZCL_OTLP_PROTOBUF_STREAM IMPLEMENTATION.


  METHOD append.
    CONCATENATE mv_hex iv_hex INTO mv_hex IN BYTE MODE.
  ENDMETHOD.


  METHOD constructor.
    mv_hex = iv_hex.
  ENDMETHOD.


  METHOD encode_bool.
    IF iv_bool = abap_true.
      encode_varint( 1 ).
    ELSE.
      encode_varint( 0 ).
    ENDIF.
    ro_ref = me.
  ENDMETHOD.


  METHOD encode_delimited.
    ASSERT xstrlen( iv_hex ) > 0.
    encode_varint( xstrlen( iv_hex ) ).
    append( iv_hex ).
    ro_ref = me.
  ENDMETHOD.


  METHOD encode_double.
* IEEE as 64-bit, little endian
    FIELD-SYMBOLS <lv_hex> TYPE x.

    ASSIGN iv_double TO <lv_hex> CASTING TYPE x.
    ASSERT <lv_hex> IS ASSIGNED.
    append( <lv_hex> ).

    ro_ref = me.

  ENDMETHOD.


  METHOD encode_field_and_type.
    DATA lv_hex TYPE x LENGTH 1.
    lv_hex = is_field_and_type-field_number * 8 + is_field_and_type-wire_type.
    append( lv_hex ).
    ro_ref = me.
  ENDMETHOD.


  METHOD encode_fixed64.
* always 8 bytes, little-endian

    DATA lv_hex TYPE x LENGTH 1.
    DATA(lv_tmp) = iv_int.
    DO 8 TIMES.
      lv_hex = lv_tmp MOD 256.
      lv_tmp = lv_tmp DIV 256.
      append( lv_hex ).
    ENDDO.

    ro_ref = me.

  ENDMETHOD.


  METHOD encode_varint.
* https://en.wikipedia.org/wiki/Variable-length_quantity
    DATA lv_lower TYPE x LENGTH 1.
    DATA lv_encoded TYPE xstring.

    ASSERT iv_int >= 0.

    DATA(lv_int) = iv_int.
    WHILE lv_int > 0.
      lv_lower = lv_int MOD 128.
      lv_int = lv_int DIV 128.
      IF lv_int <> 0.
        SET BIT 1 OF lv_lower TO 1.
      ENDIF.
      CONCATENATE lv_encoded lv_lower INTO lv_encoded IN BYTE MODE.
    ENDWHILE.
    append( lv_encoded ).
    ro_ref = me.
  ENDMETHOD.


  METHOD get.
    rv_hex = mv_hex.
  ENDMETHOD.
ENDCLASS.
