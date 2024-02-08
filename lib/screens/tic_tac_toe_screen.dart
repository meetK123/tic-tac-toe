import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_tac_game/screens/widget/tiles_view.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> grid = [];
  bool player1Turn = false;
  bool gameOver = false;

// a key to set on our Text widget, so we can measure later
  GlobalKey myTextKey = GlobalKey();

// a RenderBox object to use in state
  RenderBox? myTextRenderBox;

  @override
  void initState() {
    super.initState();
    resetGame();
    // this will be called after first draw, and then call _recordSize() method
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordSize());
  }

  void resetGame() {
    setState(() {
      grid = List.generate(3, (_) => List.filled(3, ''));
      player1Turn = true;
    });
  }

  void makeMove(int row, int col) {
    if (grid[row][col].isEmpty) {
      setState(() {
        grid[row][col] = player1Turn ? 'X' : 'O';
        player1Turn = !player1Turn;
        checkWin(row, col);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Container(
        decoration: BoxDecoration(
        /*  gradient: RadialGradient(
              colors: [
                Colors.yellow,
                Colors.red,
                Colors.purple.shade400,
              ],
              *//*center: Alignment.center,
            focal: Alignment.center,*//*
              focalRadius: 0.5,
              stops: const [0.1, 0.5, 0.75]),
*/
            gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.indigo.shade400,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20).r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Player ${player1Turn ? '1 (X)' : '2 (O)'}\'s Turn',
                  style: TextStyle(fontSize: 24.0.sm, color: Colors.white),
                ),
                20.verticalSpace,
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return TilesView(
                      callBack: () => makeMove(row, col),
                      drawText: grid[row][col],
                    );
                    return _buildTilesView(row, col);
                  },
                ),
                20.verticalSpace,
                ElevatedButton(
                  onPressed: resetGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0)
                        .r,
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0).r,
                    ),
                  ),
                  child: const Text('Reset Game'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTilesView(int row, int col) {
    return GestureDetector(
      onTap: () => makeMove(row, col),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0).r,
          gradient: LinearGradient(
            colors: [
              Colors.purpleAccent.shade100,
              Colors.deepPurpleAccent.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            grid[row][col],
            // key: myTextKey,
            style: TextStyle(
              fontSize: 48.0.sm,
              fontWeight: FontWeight.bold,
              //  color: Colors.white,
              foreground: Paint()..shader = linearGradient,
            ),
          ),
        ),
      ),
    );
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('It\'s a draw!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
    gameOver = true;
  }

  void showWinDialog(String player) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(
            'Player $player wins!',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
    gameOver = true;
  }

  void checkWin(int row, int col) {
    String currentPlayer = grid[row][col];
    // Check row
    if (grid[row][0] == currentPlayer &&
        grid[row][1] == currentPlayer &&
        grid[row][2] == currentPlayer) {
      showWinDialog(currentPlayer);
    }
    // Check column
    else if (grid[0][col] == currentPlayer &&
        grid[1][col] == currentPlayer &&
        grid[2][col] == currentPlayer) {
      showWinDialog(currentPlayer);
    }
    // Check diagonals
    else if ((grid[0][0] == currentPlayer &&
            grid[1][1] == currentPlayer &&
            grid[2][2] == currentPlayer) ||
        (grid[0][2] == currentPlayer &&
            grid[1][1] == currentPlayer &&
            grid[2][0] == currentPlayer)) {
      showWinDialog(currentPlayer);
    }
    // Check for a draw
    else if (!grid.any((row) => row.any((cell) => cell.isEmpty))) {
      showDrawDialog();
    }
  }

  void _recordSize() {
    // now we set the RenderBox and trigger a redraw
    setState(() {
      myTextRenderBox =
          myTextKey.currentContext?.findRenderObject() as RenderBox?;
    });
  }

  Shader? getTextGradient(RenderBox? renderBox) {
    if (renderBox == null) return null;
    return const LinearGradient(
      colors: <Color>[Colors.deepOrange, Colors.lightGreenAccent],
    ).createShader(Rect.fromLTWH(
        renderBox.localToGlobal(Offset.zero).dx,
        renderBox.localToGlobal(Offset.zero).dy,
        renderBox.size.width,
        renderBox.size.height));
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Colors.deepOrange, Colors.lightGreenAccent],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 50.0, 70.0));
}
