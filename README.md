# Parquet Tools in Docker

This is a small container image containing the AdoptOpenJDK 8 JRE and the parquet-tools library.

I originally created this to run on a machine with Java 9 because it wouldn't load some Hadoop libraries.
This is no longer be a limitation on Java 11 however it still comes in handy.

## Commands

All parquet-tools commands are available.
Below are a few examples of how to use this image:

### Cat

```console
$ docker run --rm -it -v $(PWD)/users.parquet:/tmp/file.parquet nathanhowell/parquet-tools cat /tmp/file.parquet

name = Alyssa
favorite_numbers:
.array = 3
.array = 9
.array = 15
.array = 20

name = Ben
favorite_color = red
favorite_numbers:
```

### Schema

```console
$ docker run --rm -it -v $(PWD)/users.parquet:/tmp/file.parquet nathanhowell/parquet-tools schema /tmp/file.parquet

message example.avro.User {
  required binary name (STRING);
  optional binary favorite_color (STRING);
  required group favorite_numbers (LIST) {
    repeated int32 array;
  }
}
```

### Metadata

```console
$ docker run --rm -it -v $(PWD)/users.parquet:/tmp/file.parquet nathanhowell/parquet-tools meta /tmp/file.parquet

file:             file:/tmp/file.parquet
creator:          parquet-mr version 1.4.3
extra:            avro.schema = {"type":"record","name":"User","namespace":"example.avro","fields":[{"name":"name","type":"string"},{"name":"favorite_color","type":["string","null"]},{"name":"favorite_numbers","type":{"type":"array","items":"int"}}]}

file schema:      example.avro.User
--------------------------------------------------------------------------------
name:             REQUIRED BINARY L:STRING R:0 D:0
favorite_color:   OPTIONAL BINARY L:STRING R:0 D:1
favorite_numbers: REQUIRED F:1
.array:           REPEATED INT32 R:1 D:1

row group 1:      RC:2 TS:109 OFFSET:4
--------------------------------------------------------------------------------
name:              BINARY SNAPPY DO:0 FPO:4 SZ:36/34/0.94 VC:2 ENC:PLAIN,BIT_PACKED ST:[no stats for this column]
favorite_color:    BINARY SNAPPY DO:0 FPO:40 SZ:32/30/0.94 VC:2 ENC:RLE,PLAIN,BIT_PACKED ST:[no stats for this column]
favorite_numbers:
.array:            INT32 SNAPPY DO:0 FPO:72 SZ:45/45/1.00 VC:5 ENC:RLE,PLAIN ST:[no stats for this column]
```


## Notes

There is an experimental native image available.
Run `make native` to compile parquet-tools with the GraalVM AOT compiler.
This reduces startup time by over a second on my development machine.
