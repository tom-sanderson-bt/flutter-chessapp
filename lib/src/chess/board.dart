import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:flutter_chesslist/src/models/chess.dart';

class ChessBoardPage extends StatefulWidget {
  static const routeName = '/chessboard';

  const ChessBoardPage({super.key, required this.puzzle});

  @override
  HomePageState createState() => HomePageState();

  final PuzzlePuzzle puzzle;
}

class HomePageState extends State<ChessBoardPage> {
  ChessBoardController controller = ChessBoardController();

  @override
  void initState() {
    super.initState();
    controller.loadFen(widget.puzzle.fen);
    controller.makeMove(
        from: widget.puzzle.last.from, to: widget.puzzle.last.to);
    controller.addListener(_onLogMove);
    controller.addListener(_onCheckMove);
  }

  void _onLogMove() {
    print("A move was made: ${controller.getFen()}");
  }

  void _onCheckMove() {
    var lastMove = controller.game.history.last;

    if (lastMove.move.fromAlgebraic == widget.puzzle.answer.from &&
        lastMove.move.toAlgebraic == widget.puzzle.answer.to) {
      _showMessage('Correct move!');
    } else {
      _showMessage('Incorrect move, try again!');
      controller.undoMove();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    controller.removeListener(_onLogMove);
    controller.removeListener(_onCheckMove);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Black to move'),
      ),
      body: Center(
        child: ChessBoard(
          controller: controller,
          boardColor: BoardColor.orange,
          boardOrientation: PlayerColor.white,
        ),
      ),
    );
  }
}
