// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todolist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodolistAdapter extends TypeAdapter<Todolist> {
  @override
  final int typeId = 0;

  @override
  Todolist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todolist(
      title: fields[0] as String,
      id: fields[1] as String,
      completed: fields[2] as bool,
      description: fields[3] as String,
      dueDate: fields[4] as DateTime,
      dueTime: fields[5] as TimeOfDay,
      priority: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Todolist obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.completed)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.dueTime)
      ..writeByte(6)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodolistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
