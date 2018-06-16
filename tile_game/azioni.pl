:- dynamic n_factorial/2, setElement/4, dim/1.

applicabile(nord, Stato) :-
  dim(D),
  nth0(P_, Stato, v),
  P is P_ + 1,
  P>D.

applicabile(sud, Stato) :-
  dim(D),
  nth0(P_, Stato, v),
  P is P_ + 1,
  P < (D * D) - D.

applicabile(ovest, Stato) :-
  dim(D),
  nth0(P, Stato, v),
  M is mod(P + 1, D),
  M =\= 1.

applicabile(est, Stato) :-
  dim(D),
  nth0(P, Stato, v),
  M is mod(P + 1, D),
  M =\= D.

trasforma(est, S, SNuovo) :-
  nth0(OldP, S, v),
  NewP is OldP + 1,
  swap(S, OldP, NewP, SNuovo).
trasforma(ovest, S, SNuovo) :-
  nth0(OldP, S, v),
  NewP is OldP - 1,
  swap(S, OldP, NewP, SNuovo).
trasforma(nord, S, SNuovo) :-
  dim(D),
  nth0(OldP, S, v),
  NewP is OldP - D,
  swap(S, OldP, NewP, SNuovo).
trasforma(sud, S, SNuovo) :-
  dim(D),
  nth0(OldP, S, v),
  NewP is OldP + D,
  swap(S, OldP, NewP, SNuovo).

maxDepth(Md) :-
  dim(D),
  n_factorial(D, F),
  Md is F / 2.

costoPasso(_, _, Costo) :-
  Costo is 1.

% swap(Lista,Pos1,Pos2,NuovaLista)
swap(Lista,Pos1,Pos2,NuovaLista):-
  nth0(Pos1, Lista, X1),
  nth0(Pos2, Lista, X2),
  setElement(Lista,Pos2,X1,Temp),
  setElement(Temp,Pos1,X2,NuovaLista).