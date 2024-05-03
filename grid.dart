import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  const Grid(
      {super.key,
      required this.gridSize,
      required this.rows,
      required this.foodPos,
      required this.snakeList});

  final double gridSize;
  final int rows;
  final int foodPos;
  final List<int> snakeList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: gridSize,
      height: gridSize,
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: rows,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        children: List.generate(
          rows * rows,
          ((index) {
            return snakeList.contains(index)
                ? (index == snakeList.last)
                    ? Box(color: Colors.green[300])
                    : Box(color: Colors.lightGreen[200])
                : (index == foodPos)
                    ? Box(color: Colors.red[400])
                    : Box(color: Colors.grey[200]);
          }
          // child: Text('$index', style: const TextStyle(fontSize: 10)),
          ),
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  const Box({super.key, required this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
