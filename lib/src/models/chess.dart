
class ApiResponse {
  String id;
  Record record;

  ApiResponse({
      required this.id,
      required this.record,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      id: json['id'],
      record: Record.fromJson(json['record']), // Use Record.fromJson for conversion
    );
  }
}


class Record {
  List<RecordPuzzle> puzzles;

  Record({
      required this.puzzles,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    var puzzlesList = json['puzzles'] as List;
    List<RecordPuzzle> puzzlesObjects = puzzlesList.map((puzzleJson) => RecordPuzzle.fromJson(puzzleJson)).toList();
    return Record(
      puzzles: puzzlesObjects,
    );
  }
}

class RecordPuzzle {
  String title;
  List<PuzzlePuzzle> puzzles;

  RecordPuzzle({
      required this.title,
      required this.puzzles,
  });

  factory RecordPuzzle.fromJson(Map<String, dynamic> json) {
    var puzzlesList = json['puzzles'] as List;
    List<PuzzlePuzzle> puzzlesObjects = puzzlesList.map((puzzleJson) => PuzzlePuzzle.fromJson(puzzleJson)).toList();
    return RecordPuzzle(
      title: json['title'],
      puzzles: puzzlesObjects,
    );
  }
}

class PuzzlePuzzle {
  String fen;
  Move last;
  Move answer;

  PuzzlePuzzle({
      required this.fen,
      required this.last,
      required this.answer,
  });

  factory PuzzlePuzzle.fromJson(Map<String, dynamic> json) {
    return PuzzlePuzzle(
      fen: json['fen'],
      last: Move.fromJson(json['last']),
      answer: Move.fromJson(json['answer']),
    );
  }

}

class Move {
  String from;
  String to;

  Move({
      required this.from,
      required this.to,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      from: json['from'],
      to: json['to']
    );
  }
}