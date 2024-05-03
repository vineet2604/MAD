import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/prefrences.dart';
import 'package:snake/Widgets/score_board.dart';
import 'Widgets/grid.dart';

enum SnakeDirection { up, down, left, right }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int rows = 12;

  var snakeDirection = SnakeDirection.right;
  bool gameHasStarted = false;
  int score = 0;
  List<int> snake = [0, 1, 2];
  late int food = Random().nextInt(rows * rows - 3) + 3;

  // this is to make the grid responsive on all screens
  late double gridSize = MediaQuery.of(context).size.width > 500
      ? 500
      : MediaQuery.of(context).size.width - 16;

  int _highScore = Prefrences.getHighScore();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < 0 && snakeDirection != SnakeDirection.right) {
            setState(() => snakeDirection = SnakeDirection.left);
          } else if (details.delta.dx > 0 &&
              snakeDirection != SnakeDirection.left) {
            setState(() => snakeDirection = SnakeDirection.right);
          }
        },
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < 0 && snakeDirection != SnakeDirection.down) {
            setState(() => snakeDirection = SnakeDirection.up);
          } else if (details.delta.dy > 0 &&
              snakeDirection != SnakeDirection.up) {
            setState(() => snakeDirection = SnakeDirection.down);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ScoreBoard(score: score, highScore: _highScore),
                  Grid(
                    gridSize: gridSize,
                    snakeList: snake,
                    rows: rows,
                    foodPos: food,
                  ),
                  // const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: gameHasStarted ? pauseGame : startGame,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(!gameHasStarted ? 'Start' : 'Pause'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void startGame() {
    setState(() => gameHasStarted = true);
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (gameHasStarted) {
        setState(() {
          // check if snake hits it's body
          if (isGameOver() || !gameHasStarted) {
            timer.cancel();
            showGameOverStats();
          }

          // move the snake
          else {
            snake.add(nextSnakePos());
            // check if snake eats the food
            if (snake.last != food) {
              snake.removeAt(0);
            } else {
              eatFood();
            }
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  int nextSnakePos() {
    int add = 0;
    switch (snakeDirection) {
      case SnakeDirection.right:
        add = snake.last % rows == rows - 1 ? -rows + 1 : 1;
        break;
      case SnakeDirection.left:
        add = snake.last % rows == 0 ? rows - 1 : -1;
        break;
      case SnakeDirection.up:
        add = snake.last / rows >= 1 ? -rows : rows * (rows - 1);
        break;
      case SnakeDirection.down:
        add = snake.last / rows < rows - 1 ? rows : -(rows * (rows - 1));
        break;
    }
    return snake.last + add;
  }

  void pauseGame() {
    setState(() {
      gameHasStarted = !gameHasStarted;
    });
  }

  void eatFood() {
    score++;
    setState(() {
      while (snake.contains(food)) {
        food = Random().nextInt(rows * rows);
      }
    });
  }

  bool isGameOver() {
    if (snake.sublist(0, snake.length - 1).contains(snake.last)) {
      return true;
    }
    return false;
  }

  void showGameOverStats() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            resetGame();
            return true;
          },
          child: AlertDialog(
            title: const Text('GAME OVER'),
            content: Text('Score: $score'),
            actions: [
              ElevatedButton(
                onPressed: resetGame,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('PLAY AGAIN'),
                ),
              ),
              OutlinedButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('QUIT', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (score > _highScore) {
      await Prefrences.saveHighScore(score);
      setState(() {
        _highScore = Prefrences.getHighScore();
      });
    }
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      snakeDirection = SnakeDirection.right;
      gameHasStarted = false;
      score = 0;
      snake = [0, 1, 2];
      food = 50;
    });
  }
}
