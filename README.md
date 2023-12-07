# Balloon-Game
Balloon Bursting Game in 16 Bit Assembly Language 8086 Architecture Built for semester project
# Game Development Documentation: Assembly Language Game

1. Introduction
The `baloon.asm` is an Assembly language game developed as part of a Computer Organization and Assembly Language (COAL) project. The game involves balloons rising from the bottom of the screen, and the player must press the key corresponding to the balloon to pop it and increase their score. The game continues until the player has popped a certain number of balloons, at which point the game ends and the final score is displayed.

2. Objectives
The primary objectives of the game development project are as follows:
- Demonstrate comprehension of Instruction Set Architecture.
- Implement memory addressing, branching, bit manipulation, stack operations, subroutines, string operations, and interrupts in assembly language.
- Develop a playable game that adheres to the specified requirements.

3. Game Choice
The game chosen for this project is a balloon popping game. The player must press the key corresponding to the balloon on the screen to pop it and increase their score.

4. Documentation Elements

- Introduction Message:
The game introduces itself with a start screen that displays the game's name and instructions. The roll numbers of the developers are also displayed on this screen.

 Game Menu:
The game does not have a traditional menu. Instead, the start screen serves as the game's menu, displaying the game's name and instructions on how to play.

Game Screen:
The game screen is where the main game loop takes place. It repeatedly prints balloons at the bottom of the screen, waits for a short delay, then scrolls the screen up. The player can pop the balloons by pressing the key corresponding to the balloon on the screen.

Score/Progress Display:
The player's score is displayed on the screen. The score is incremented each time the player pops a balloon.

Game Over/Win Message:
The game ends when the player has popped a certain number of balloons. At this point, a game over message is displayed, along with the player's final score.
