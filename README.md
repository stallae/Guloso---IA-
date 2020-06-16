# Pegue o Guloso - A* pathfinding algorithm

#### Descrição geral do projeto

Esse projeto foi desenvolvido para a disciplina de Inteligência Artificial, da Faculdade de Tecnologia da UNICAMP. A proposta do trabalho foi de desenvolver um programa com os requisitos:

    * Criação de uma heurística admissível;
    * Criação de uma heurística não admissível;
    * Mostrar as possíveis soluções e qual foi a escolhida pelo A*. Isso deve ser apresentado utilizando a árvore 
    de busca e as listas de nós abertos e fechados;
    * Ter a opção de trocar a heurística admissível por uma não admissível e executar o algoritmo. A partir disso, 
    mostrar que a solução encontrada não foi a ótima;

Com os requisitos acima, decidimos desenvolver um jogo em que é uma busca por hambúrgueres, mas para deixar o projeto interessante, fizemos com que um usuário possa jogar e no final de cada fase, será comparado a solução do usuário com a obtida pela IA. Se o usuário fizer o mesmo número de passos que a IA para chegar ao objetivo, ele ganha a fase, caso contrário, perde.

#### Instruções

As instruções para conseguir jogar o Pegue o guloso são:

    * Movimentação do jogador: Setinhas do teclado
    * Mudança de câmera: Botão direito do mouse
    * Menu: ESC

Dentro do menu, existem as opções para reiniciar a fase ou sair do jogo. Quando o usuário se deparar com uma situação que é impossível chegar ao hambúrguer, ele pode usar a funcionalidade de reiniciar a fase para recomeçar. Ao final de cada fase, existem 4 opções:

    * Admissível - IA percorre a fase mostrando o caminho ótimo
    * Não admissível - IA percorre a fase mostrando o caminho obtido com a heurística não admissível
    * Next lvl - Nova fase aleatória é gerada
    * Sair - Fecha o jogo

Dentro da execução da IA (nas opções admissível ou não admissível) existe o botão DEBUGAR. Esse botão é responsável de pintar o mapa com as listas open e closed. Os nós representados com a cor roxa são os nós da lista closed, e os laranjas, da open.

#### Exemplo da utilização da opção DEBUGAR

![Opcao debugar](/Capturas/opcao_debugar.png?raw=true "DEBUGAR")

#### Exemplo de mudança de câmera

A câmera de perto fica como demonstrado na figura abaixo.

![Camera de perto](/Capturas/camera_perto.png?raw=true "Camera de perto")

A câmera de longe fica como demonstrado na figura abaixo.

![Camera de longe](/Capturas/camera_longe.png?raw=true "Camera de longe")

#### Menu

![Menu](/Capturas/menu.png?raw=true "Menu")


Estamos abertos a dúvidas e melhorias, fique a vontade para criar uma issue :)

Desenvolvido por:
- Arthur Guedes
- Gabriel Domingues
- Leonardo Ponte
- Matheus Cumpian
- Matheus Padovani
