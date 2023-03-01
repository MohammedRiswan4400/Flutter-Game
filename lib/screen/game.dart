import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Future<void> _handleRefresh() async {
    return await Future.delayed(
      Duration(
        seconds: 1,
      ),
    );
  }

  bool oTurn = true;

  List<String> displayXO = ["", "", "", "", "", "", "", "", ""];
  List<int> matchedIndexes = [];

  int attampts = 0;
  int oScore = 0;
  int xScore = 0;
  int filledBox = 0;
  String resultDecleration = "";
  bool winnerFound = false;

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  int restart = 0;
  Timer? timer;

  static var costonFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTime();
        }
      });
    });
  }

  void stopTime() {
    timer?.cancel();
  }

  void resetTimer() {
    seconds = maxSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 34, 79),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Color.fromARGB(255, 25, 21, 22),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Player O",
                            style: costonFontWhite,
                          ),
                          Text(
                            oScore.toString(),
                            style: costonFontWhite,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Player X",
                            style: costonFontWhite,
                          ),
                          Text(
                            xScore.toString(),
                            style: costonFontWhite,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _tapped(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: matchedIndexes.contains(index)
                              ? Colors.blue
                              : Colors.amber,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 5,
                            color: Color.fromARGB(255, 214, 34, 79),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            displayXO[index],
                            style: GoogleFonts.coiny(
                                textStyle: TextStyle(
                                    fontSize: 64,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resultDecleration,
                      style: costonFontWhite,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTimer(),
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        // print("...............................................");
                        _navigateAndDisplaySelection(context);
                      },
                      icon: const Icon(
                        Icons.refresh,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      setState(
        () {
          if (oTurn && displayXO[index] == "") {
            displayXO[index] = "O";
          } else if (!oTurn && displayXO[index] == "") {
            displayXO[index] = "X";
          }
          filledBox++;

          oTurn = !oTurn;
          _checkWinner();
        },
      );
    }
  }

  void _checkWinner() {
    // 1st Row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != "") {
      setState(
        () {
          resultDecleration = "Player " + displayXO[0] + " Wins";
          matchedIndexes.addAll([0, 1, 2]);
          stopTime();
          _updateScore(displayXO[0]);
        },
      );
    }
    // 2nd Row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != "") {
      setState(
        () {
          resultDecleration = "Player " + displayXO[3] + " Wins";
          matchedIndexes.addAll([3, 4, 5]);
          stopTime();
          _updateScore(displayXO[3]);
        },
      );
    }
    // 3rd Row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != "") {
      setState(
        () {
          resultDecleration = "Player " + displayXO[6] + " Wins";
          matchedIndexes.addAll([6, 7, 8]);
          stopTime();
          _updateScore(displayXO[6]);
        },
      );
    }
    // 1st col
    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != "") {
      setState(
        () {
          resultDecleration = "Player " + displayXO[0] + " Wins";
          matchedIndexes.addAll([0, 3, 6]);
          stopTime();
          _updateScore(displayXO[0]);
        },
      );
    }
    // 2nd col
    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != "") {
      setState(
        () {
          resultDecleration = "Player " + displayXO[1] + " Wins";
          matchedIndexes.addAll([1, 4, 7]);
          stopTime();
          _updateScore(displayXO[1]);
        },
      );
    }
    // 3rd col
    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != "") {
      setState(
        () {
          resultDecleration = "Player " + displayXO[2] + " Wins";
          matchedIndexes.addAll([2, 5, 8]);
          stopTime();
          _updateScore(displayXO[2]);
        },
      );
    }
    // 1st diagonal
    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != "") {
      setState(
        () {
          resultDecleration = "Player " + displayXO[0] + " Wins";
          matchedIndexes.addAll([0, 4, 8]);
          stopTime();
          _updateScore(displayXO[0]);
        },
      );
    }
    // 2nd diagonal
    if (displayXO[6] == displayXO[4] &&
        displayXO[6] == displayXO[2] &&
        displayXO[6] != "") {
      setState(
        () {
          resultDecleration = "Player " + displayXO[6] + "  Wins";
          matchedIndexes.addAll([6, 4, 2]);
          stopTime();
          _updateScore(displayXO[6]);
        },
      );
    }
    if (!winnerFound && filledBox > 8) {
      setState(() {
        resultDecleration = "Nobody Wins!";
        stopTime();
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == "O") {
      oScore++;
    } else if (winner == "X") {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearAgain() {
    setState(
      () {
        for (int i = 0; i < 9; i++) {
          displayXO[i] = "";
        }
        resultDecleration = "";
      },
    );
    filledBox = 0;
    // oScore = 0;
    // xScore = 0;
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: AlwaysStoppedAnimation(
                    Color.fromARGB(255, 214, 34, 79),
                  ),
                  strokeWidth: 8,
                  backgroundColor: Colors.green,
                ),
                Center(
                  child: Text(
                    "$seconds",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40),
                  ),
                )
              ],
            ),
          )
        : ElevatedButton(
            onPressed: () {
              startTimer();
              _clearAgain();
              attampts++;
            },
            child: Text(
              attampts == 0 ? "Start" : "Play Again!",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(10),
            ),
          );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }
}
