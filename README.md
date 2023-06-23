# Pegue o Guloso - A* pathfinding algorithm

#### Project Overview

This project was developed for the Artificial Intelligence course at UNICAMP (University of Campinas) College of Technology. The goal of the project was to develop a program with the following requirements:

    * Creation of an admissible heuristic
    * Creation of a non-admissible heuristic
    * Display the possible solutions and the one chosen by A*. This should be presented using the search tree and the lists of open and closed nodes.
    * Have the option to swap the admissible heuristic with a non-admissible one and run the algorithm. Show that the solution found is not optimal.

With the requirements above, we decided to develop a game where the objective is to search for hamburgers. To make the project more interesting, we allowed the user to play the game. At the end of each level, the user's solution is compared to the one obtained by the AI. If the user takes the same number of steps as the AI to reach the goal, they win the level; otherwise, they lose.

#### Instructions

The instructions to play Pegue o Guloso are as follows:

    * Player movement: Arrow keys
    * Camera change: Right mouse button
    * Menu: ESC

Inside the menu, there are options to restart the level or quit the game. If the user encounters a situation where it is impossible to reach the hamburger, they can use the restart level functionality to start over. At the end of each level, there are four options:

    * Admissible - AI completes the level showing the optimal path
    * Non-admissible - AI completes the level showing the path obtained with the non-admissible heuristic
    * Next lvl - Generates a new random level
    * Quit - Exits the game

During the execution of the AI (in the admissible or non-admissible options), there is a DEBUG button. This button is responsible for painting the map with the open and closed lists. The nodes represented with the purple color are the nodes in the closed list, and the orange ones are in the open list.

#### Example of using the DEBUG option

![Debug Option](/Capturas/opcao_debugar.png?raw=true "DEBUG")

#### Example of camera change

The close-up camera view is shown in the figure below.

![Close-up Camera](/Capturas/camera_perto.png?raw=true "Close-up Camera")

The distant camera view is shown in the figure below.

![Distant Camera](/Capturas/camera_longe.png?raw=true "Distant Camera")

#### Menu

![Menu](/Capturas/menu.png?raw=true "Menu")

We are open to questions and improvements. Feel free to create an issue :)

Developed by:
- Arthur Guedes
- Gabriel Domingues
- Leonardo Ponte
- Matheus Cumpian
- Matheus Padovani
