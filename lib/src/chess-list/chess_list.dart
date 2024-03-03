import 'package:flutter/material.dart';
import 'package:flutter_chesslist/src/contants/contants.dart';
import 'package:flutter_chesslist/src/models/chess.dart';
import 'package:flutter_chesslist/src/video/video.dart';
import '../chess/board.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChessListView extends StatefulWidget {
  const ChessListView({super.key});

  @override
  ChessListViewState createState() => ChessListViewState();

  static const routeName = '/tacticsList';
}

class ChessListViewState extends State<ChessListView> {
  Future<ApiResponse> fetchData() async {
    final response = await http.get(Uri.parse(dataUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      return ApiResponse.fromJson(decodedJson);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Tactics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, ChessBoardPage.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder<ApiResponse>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.record.puzzles.length ?? 0,
              itemBuilder: (context, index) {
                var item = snapshot.data?.record.puzzles[index];

                return ExpansionTile(
                    title: Text(item!.title),
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.video_library),
                        title: const Text('Video'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(),
                            ),
                          );
                        },
                      ),
                      ...item.puzzles
                          .asMap()
                          .entries
                          .map((entry) {
                            int index = entry.key;
                            PuzzlePuzzle puzzle = entry.value;

                            return ListTile(
                                title: Text('Puzzle ${index + 1}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChessBoardPage(puzzle: puzzle),
                                    ),
                                  );
                                });
                          })
                          .toList()
                          .cast<Widget>(),
                    ]);
              },
            );
          }
        },
      ),
    );
  }
}
