mobility_heuristique(Grid, Val):-
    % get max player possible moves
	((((get_legal_coordinates(Grid,1,MaxMoves),!, length(MaxMoves,MaxCount)) 
	 ;
	 MaxCount is 0),
	 
	 % get min player possible moves 
	((get_legal_coordinates(Grid,2,MinMoves),!, length(MinMoves,MinCount))
	 ;
	 MinCount is 0)),

	% compare 
	(Delta is MaxCount - MinCount,
	Val is Delta ).

x_evaluation(GridId,Val):-
	% get X cases values  
	dimension(N),
	A1 is N-1,
	slot(GridId,coordinate(2,2),C1),
	slot(GridId,coordinate(2,A1),C2),
	slot(GridId,coordinate(A1,2),C3),
	slot(GridId,coordinate(A1,A1),C4),
	% assign each corner a grade 1/4 according to it's value (empty\max\min)
	((C1 =:= 0,!,C1Val is 0) ; (C1 =:= 1,!,C1Val is -0.25) ; (C1Val is 0.25)),
	((C2 =:= 0,!,C2Val is 0) ; (C2 =:= 1,!,C2Val is -0.25) ; (C2Val is 0.25)),
	((C3 =:= 0,!,C3Val is 0) ; (C3 =:= 1,!,C3Val is -0.25) ; (C3Val is 0.25)),
	((C4 =:= 0,!,C4Val is 0) ; (C4 =:= 1,!,C4Val is -0.25) ; (C4Val is 0.25)),
	% sum result of all corners 
	Val is C1Val+C2Val+C3Val+C4Val.	   

c_evaluation(GridId,Val):-
	% get X cases values  
	dimension(N),
	A1 is N-1,
	slot(GridId,coordinate(1,2),C1),
	slot(GridId,coordinate(2,1),C2),
	slot(GridId,coordinate(1,A1),C3),
	slot(GridId,coordinate(2,N),C4),
	slot(GridId,coordinate(A1,1),C5),
	slot(GridId,coordinate(N,2),C6),
	slot(GridId,coordinate(A1,N),C7),
	slot(GridId,coordinate(N,A1),C8),
	% assign each corner a grade 1/4 according to it's value (empty\max\min)
	((C1 =:= 0,!,C1Val is 0) ; (C1 =:= 1,!,C1Val is -0.125) ; (C1Val is 0.125)),
	((C2 =:= 0,!,C2Val is 0) ; (C2 =:= 1,!,C2Val is -0.125) ; (C2Val is 0.125)),
	((C3 =:= 0,!,C3Val is 0) ; (C3 =:= 1,!,C3Val is -0.125) ; (C3Val is 0.125)),
	((C4 =:= 0,!,C4Val is 0) ; (C4 =:= 1,!,C4Val is -0.125) ; (C4Val is 0.125)),
	((C5 =:= 0,!,C5Val is 0) ; (C5 =:= 1,!,C5Val is -0.125) ; (C5Val is 0.125)),
	((C6 =:= 0,!,C6Val is 0) ; (C6 =:= 1,!,C6Val is -0.125) ; (C6Val is 0.125)),
	((C7 =:= 0,!,C7Val is 0) ; (C7 =:= 1,!,C7Val is -0.125) ; (C7Val is 0.125)),
	((C8 =:= 0,!,C8Val is 0) ; (C8 =:= 1,!,C8Val is -0.125) ; (C8Val is 0.125)),
	% sum result of all corners 
	Val is C1Val+C2Val+C3Val+C4Val+C5Val+C6Val+C7Val+C8Val.	      