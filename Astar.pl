% stato rappresentato da node(S, ActionsListForS, costoCamminoAttuale, costoEuristica)

:- ['./labyrinth/loader.pl', 'utils.pl'].

start:-
  aStar(S),
  write(S).

aStar(Solution) :-
  initialPosition(S),
  heuristic(S, _, L),
  star([node(S, [], 0, L)], [], Solution),
  write(Solution).

% star(CodaNodiDaEsplorare, ExpandedNodes, Solution)
star([node(S, ActionsListForS, _, _)|_], _, ActionsListForS) :-
  finalPosition(S).
star([node(S, ActionsListForS, ActualPathCost, HeuristicCost)|Frontier], ExpandedNodes, Solution) :-
  %write("\nNodo in analisi: "), write(S),
  %write("\nLista azioni: "), write(ActionsListForS),
  %write("\nCosto: "), write(ActualPathCost), write(" | Euristica: "), write(HeuristicCost),
  findall(Az, allowed(Az, S), AllowedActionsList),
  %write("\nAzioni applicabili: "), write(AllowedActionsList),
  generateSons(node(S,ActionsListForS, ActualPathCost, HeuristicCost), AllowedActionsList, ExpandedNodes, SChilderenList),
% write("\nFigli trovati: "), write(SChilderenList), write("\n"),
  appendOrdinata(SChilderenList, Frontier, NewFrontier),
  star(NewFrontier, [S|ExpandedNodes], Solution).
  %write("\n\n___________________________"),
  %write("\n|FRONTIERA ATTUALE:\n|"),
  %stampaFrontiera(NewFrontier),
  %length(ExpandedNodes, EN),
  %write("\n|\n| NODI ESPANSI: "), write(EN),
  %write("\n|___________________________"),
  

% generateSons(Node, AllowedActionsList, ExpandedNodes, ChildNodesList)
generateSons(_, [], _, []).
generateSons(node(S, ActionsListForS, PathCostForS, HeuristicOfS),
             [Action|OtherActions],
             ExpandedNodes,
             [node(NewS, ActionsListForNewS, PathCostForNewS, HeuristicCostForNewS)|OtherChildren]) :-
  move(Action, S, NewS),
  \+member(NewS, ExpandedNodes),
  cost(S, NewS, Cost),
  PathCostForNewS is PathCostForS + Cost,
  %write("\nCalcolo heuristic per "), write(Action),
  heuristic(NewS, HSol, HeuristicCostForNewS),
  %write("\n"), write(HSol), write(" | "), write(HeuristicCostForNewS),
  append(ActionsListForS, [Action], ActionsListForNewS),
  generateSons(node(S, ActionsListForS, PathCostForS, HeuristicOfS), OtherActions, ExpandedNodes, OtherChildren),
  !.
% serve per backtrackare sulle altre azione se l'Action porta ad uno stato già visitato o che fallisce
generateSons(Node, [_|OtherActions], ExpandedNodes, ChildNodesList) :-
  generateSons(Node, OtherActions, ExpandedNodes, ChildNodesList),
  !.
