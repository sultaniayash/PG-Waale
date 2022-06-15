class WordModel {
  String id;
  String word;
  List<Definition> definitions;
  List<Example> examples;
  String note;

  WordModel({
    this.id,
    this.word,
    this.definitions,
    this.examples,
    this.note,
  });

  factory WordModel.empty() => WordModel(
        id: "",
        word: "",
        definitions: [],
        examples: [],
        note: "",
      );

  factory WordModel.fromMap(Map data) => WordModel(
        id: data["_id"] ?? "",
        word: data["word"] ?? "",
        definitions: List<Definition>.from((data["definitions"] ?? []).map((x) => Definition.fromMap(x))),
        examples: List<Example>.from((data["examples"] ?? []).map((x) => Example.fromMap(x))),
        note: data["note"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "word": word,
        "definitions": definitions.map((x) => x.toMap()).toList(),
        "examples": examples.map((x) => x.toMap()).toList(),
        "note": note,
      };
}

class Definition {
  String source;
  String text;
  String partOfSpeech;

  Definition({
    this.source,
    this.text,
    this.partOfSpeech,
  });

  factory Definition.fromMap(Map data) => Definition(
        source: data["source"] ?? "",
        text: data["text"] ?? "",
        partOfSpeech: data["partOfSpeech"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "source": source,
        "text": text,
        "partOfSpeech": partOfSpeech,
      };
}

class Example {
  String url;
  String title;
  String text;

  Example({
    this.url,
    this.title,
    this.text,
  });

  factory Example.fromMap(Map data) => Example(
        url: data["url"] ?? "",
        title: data["title"] ?? "",
        text: data["text"] ?? "",
      );

  Map<String, String> toMap() => {
        "url": url,
        "title": title,
        "text": text,
      };
}
