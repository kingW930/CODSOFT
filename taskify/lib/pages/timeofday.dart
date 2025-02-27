import 'package:hive/hive.dart';
import 'package:flutter/material.dart';



class TimeofdayAdapter extends TypeAdapter<TimeOfDay>{
  @override
  final int typeId = 1;
  
  @override
  TimeOfDay read(BinaryReader reader) {
  final hour = reader.readInt();
  final minute = reader.readInt();
  return TimeOfDay(hour: hour, minute: minute);
  }
  
  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeInt(obj.hour);
    writer.writeInt(obj.minute);
  }
}
