import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'schema_util.dart';
import 'serializers.dart';

part 'foods_record.g.dart';

abstract class FoodsRecord implements Built<FoodsRecord, FoodsRecordBuilder> {
  static Serializer<FoodsRecord> get serializer => _$foodsRecordSerializer;

  @nullable
  String get name;

  @nullable
  int get price;

  @nullable
  @BuiltValueField(wireName: 'url_image')
  String get urlImage;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(FoodsRecordBuilder builder) => builder
    ..name = ''
    ..price = 0
    ..urlImage = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('foods');

  static Stream<FoodsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  FoodsRecord._();
  factory FoodsRecord([void Function(FoodsRecordBuilder) updates]) =
      _$FoodsRecord;
}

Map<String, dynamic> createFoodsRecordData({
  String name,
  int price,
  String urlImage,
}) =>
    serializers.serializeWith(
        FoodsRecord.serializer,
        FoodsRecord((f) => f
          ..name = name
          ..price = price
          ..urlImage = urlImage));

FoodsRecord get dummyFoodsRecord {
  final builder = FoodsRecordBuilder()
    ..name = dummyString
    ..price = dummyInteger
    ..urlImage = dummyImagePath;
  return builder.build();
}

List<FoodsRecord> createDummyFoodsRecord({int count}) =>
    List.generate(count, (_) => dummyFoodsRecord);
