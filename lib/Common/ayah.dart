import 'package:hive_flutter/hive_flutter.dart';
part 'ayah.g.dart';

@HiveType(typeId: 2)
class AyahBM {
  @HiveField(0)
  String ayah;
  @HiveField(1)
  int ayahnum;
  @HiveField(2)
  int surahnum;
  @HiveField(3)
  String? translation;
  AyahBM(this.ayah, this.ayahnum, this.surahnum,this.translation);
}
