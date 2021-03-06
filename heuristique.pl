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
	Val is Delta )).

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

stable_count_evaluation(GridId,StableVal,MaxCount,MinCount):-
	stable_count(GridId,MaxCount,0,MinCount,0,1,1),
	TotalCount is MaxCount + MinCount + 1,
	StableVal is (MaxCount - MinCount)/TotalCount.

stable_count(Id,MaxTotal,MaxTemp,MinTotal,MinTemp,I,J):-
	slot(Id,coordinate(I,J),CurrentVal),
	((CurrentVal =:= 0,!, NewMaxTemp is MaxTemp, NewMinTemp is MinTemp); %coordinate empty
	(CurrentVal =:= 2,!, NewMinTemp is MinTemp + 1, NewMaxTemp is MaxTemp); %other player owns coordinate
	((is_stable(coordinate(I,J),Id,CurrentVal),!,(NewMaxTemp is MaxTemp + 1,NewMinTemp is MinTemp)); %piece is stable
	(NewMaxTemp is MaxTemp, NewMinTemp is MinTemp))), %piece is not stable

	dimension(N),
	((I=:=N, J=:=N,!,MaxTotal is NewMaxTemp, MinTotal is NewMinTemp);
	(get_next_sequential_index(I,J,NewI,NewJ,N),
	stable_count(Id,MaxTotal,NewMaxTemp,MinTotal,NewMinTemp,NewI,NewJ))).

is_stable(coordinate(I,J),Id,CurrentVal):-
	CurrentVal =:= 1,
	dimension(N),
	%corners are stable
	(
	(I =:= 1, J =:= 1);
	(I =:= 1, J =:= N);
	(I =:= N, J =:= 1);
	(I =:= N, J =:= N);
	% pieces at the edge of the grid are stable if all pieces next to them are stable
	(I =:= 1, J > 1, NewJ is J-1,slot(Id,coordinate(I,NewJ),NewCurrentVal),is_stable_left(coordinate(I,NewJ),Id,NewCurrentVal));
	(I =:= N, J > 1, NewJ is J-1,slot(Id,coordinate(I,NewJ),NewCurrentVal),is_stable_left(coordinate(I,NewJ),Id,NewCurrentVal));
	(I =:= 1, J < N, NewJ is J+1,slot(Id,coordinate(I,NewJ),NewCurrentVal),is_stable_right(coordinate(I,NewJ),Id,NewCurrentVal));
	(I =:= N, J < N, NewJ is J+1,slot(Id,coordinate(I,NewJ),NewCurrentVal),is_stable_right(coordinate(I,NewJ),Id,NewCurrentVal));
	(I > 1, J =:= 1, NewI is I-1,slot(Id,coordinate(NewI,J),NewCurrentVal),is_stable_up(coordinate(NewI,J),Id,NewCurrentVal));
	(I > 1, J =:= N, NewI is I-1,slot(Id,coordinate(NewI,J),NewCurrentVal),is_stable_up(coordinate(NewI,J),Id,NewCurrentVal));
	(I < N, J =:= 1, NewI is I+1,slot(Id,coordinate(NewI,J),NewCurrentVal),is_stable_down(coordinate(NewI,J),Id,NewCurrentVal));
	(I < N, J =:= N, NewI is I+1,slot(Id,coordinate(NewI,J),NewCurrentVal),is_stable_down(coordinate(NewI,J),Id,NewCurrentVal));
	% pieces that are at the edge of the grid in a row or column without empty places are stable
	(I =:= 1, full_row(coordinate(1,1), Id));
	(I =:= N, full_row(coordinate(N,1), Id));
	(J =:= 1, full_column(coordinate(1,1), Id));
	(J =:= N, full_column(coordinate(1,N), Id));
	%if rows/columns are full with own pieces from the edge on + row/column next to them is full --> piece in full  row/column is stable
	(I > 1, NewI is I-1,own_rows_up(coordinate(NewI,1),Id),full_row(coordinate(I,1),Id));
	(I < N, NewI is I+1,own_rows_down(coordinate(NewI,1),Id),full_row(coordinate(I,1),Id));
	(J > 1, NewJ is J-1,own_columns_left(coordinate(1,NewJ),Id),full_column(coordinate(I,1),Id));
	(J < N, NewJ is J+1,own_columns_right(coordinate(1,NewJ),Id),full_column(coordinate(I,1),Id));
	% if rows/columns are full with own pieces from the edge on + row/colum is to at least one edge full with own pieces --> piece is stable
	((I > 1, NewI is I-1, own_rows_up(coordinate(NewI,1),Id),slot(Id,coordinate(I,J),CurrentVal),
	  (is_stable_left(coordinate(I,J),Id,CurrentVal);is_stable_right(coordinate(I,J),Id,CurrentVal))));
	((I < N, NewI is I+1, own_rows_down(coordinate(NewI,J),Id),slot(Id,coordinate(I,J),CurrentVal),
	  (is_stable_left(coordinate(I,J),Id,CurrentVal);is_stable_right(coordinate(I,J),Id,CurrentVal))));
	((J > 1, NewJ is J-1, own_columns_left(coordinate(I,NewJ),Id),slot(Id,coordinate(I,J),CurrentVal),
	  (is_stable_left(coordinate(I,J),Id,CurrentVal);is_stable_right(coordinate(I,J),Id,CurrentVal))));
	((J < N, NewJ is J+1, own_columns_right(coordinate(I,NewJ),Id),slot(Id,coordinate(I,J),CurrentVal),
	   (is_stable_up(coordinate(I,J),Id,CurrentVal);is_stable_down(coordinate(I,J),Id,CurrentVal))));
	%(1) if diagonals in one direction are full with own pieces from the corner on + diagonal of own pieces to at least one edge
	%     --> piece is stable
	%(2) if diagonals in one direction are full with own pieces from the corner on + diagonal without empty spaces
	%     --> piece in diagonal without empty spaces is stable
	((J > 1,!,NewJ is J-1,own_diagonals_south_west(coordinate(I,NewJ),Id),slot(coordinate(I,J),Id,CurrentVal),
	    ((is_stable_north_west(coordinate(I,J),Id,CurrentVal);is_stable_south_east(coordinate(I,J),Id,CurrentVal));% (1)
	     (full_diagonal_north_west(coordinate(I,J),Id),full_diagonal_south_east(coordinate(I,J),Id))))); % (2)

	 ((I < N,!,NewI is I+1,own_diagonals_south_west(coordinate(NewI,J),Id),slot(coordinate(I,J),Id,CurrentVal),
	    ((is_stable_north_west(coordinate(I,J),Id,CurrentVal);is_stable_south_east(coordinate(I,J),Id,CurrentVal)); % (1)
	     (full_diagonal_north_west(coordinate(I,J),Id),full_diagonal_south_east(coordinate(I,J),Id))))); % (2)

	((J > 1,!,NewJ is J-1,own_diagonals_north_east(coordinate(I,NewJ),Id),slot(coordinate(I,J),Id,CurrentVal),
	    ((is_stable_north_west(coordinate(I,J),Id,CurrentVal);is_stable_south_east(coordinate(I,J),Id,CurrentVal)); % (1)
	      (full_diagonal_north_west(coordinate(I,J),Id),full_diagonal_south_east(coordinate(I,J),Id))))); % (2)

	((I < N,!,NewI is I+1,own_diagonals_north_east(coordinate(NewI,J),Id),slot(coordinate(I,J),Id,CurrentVal),
	    ((is_stable_north_west(coordinate(I,J),Id,CurrentVal);is_stable_south_east(coordinate(I,J),Id,CurrentVal)); % (1)
	      (full_diagonal_north_west(coordinate(I,J),Id),full_diagonal_south_east(coordinate(I,J),Id))))); % (2)

	((J > 1,!,NewJ is J-1,own_diagonals_north_west(coordinate(I,NewJ),Id),slot(coordinate(I,J),Id,CurrentVal),
	    ((is_stable_north_east(coordinate(I,J),Id,CurrentVal);is_stable_south_west(coordinate(I,J),Id,CurrentVal)); % (1)
	    (full_diagonal_north_east(coordinate(I,J),Id),full_diagonal_south_west(coordinate(I,J),Id))))); % (2)

	((I > 1,!,NewI is I-1,own_diagonals_north_west(coordinate(NewI,J),Id),slot(coordinate(I,J),Id,CurrentVal),
	    ((is_stable_north_east(coordinate(I,J),Id,CurrentVal);is_stable_south_west(coordinate(I,J),Id,CurrentVal)); % (1)
	     (full_diagonal_north_east(coordinate(I,J),Id),full_diagonal_south_west(coordinate(I,J),Id))))); % (2)

	((J < N,!,NewJ is J+1,own_diagonals_south_east(coordinate(I,NewJ),Id),slot(coordinate(I,J),Id,CurrentVal),
	    ((is_stable_north_east(coordinate(I,J),Id,CurrentVal);is_stable_south_west(coordinate(I,J),Id,CurrentVal)); % (1)
	     (full_diagonal_north_east(coordinate(I,J),Id),full_diagonal_south_west(coordinate(I,J),Id))))); % (2)

	((I < N,!,NewI is I+1,own_diagonals_south_east(coordinate(NewI,J),Id),slot(coordinate(I,J),Id,CurrentVal),
	    ((is_stable_north_east(coordinate(I,J),Id,CurrentVal);is_stable_south_west(coordinate(I,J),Id,CurrentVal)); % (1)
	     (full_diagonal_north_east(coordinate(I,J),Id),full_diagonal_south_west(coordinate(I,J),Id))))) % (2)
	).


is_stable_left(coordinate(I,J),Id,CurrentVal):-
	CurrentVal =:= 1,
	(J =:= 1;
        (J > 1, NewJ is J-1, slot(Id,corrdinate(I,NewJ),NewCurrentVal),is_stable_left(coordinate(I,NewJ),Id,NewCurrentVal))).

is_stable_right(coordinate(I,J),Id,CurrentVal):-
	CurrentVal =:= 1,
	dimension(N),
	(J =:= N;
	(J < N, NewJ is J+1, slot(Id,corrdinate(I,NewJ),NewCurrentVal),is_stable_right(coordinate(I,NewJ),Id,NewCurrentVal))).

is_stable_up(coordinate(I,J),Id,CurrentVal):-
	CurrentVal =:= 1,
	(I =:= 1;
	(I > 1, NewI is I-1, slot(Id,corrdinate(NewI,J),NewCurrentVal),is_stable_up(coordinate(NewI,J),Id,NewCurrentVal))).

is_stable_down(coordinate(I,J),Id,CurrentVal):-
	CurrentVal =:= 1,
	dimension(N),
	(I =:= N;
	(I < N, NewI is I+1, slot(Id,corrdinate(NewI,J),NewCurrentVal),is_stable_down(coordinate(NewI,J),Id,NewCurrentVal))).

is_stable_north_west(coordinate(I,J),Id,CurrentVal):-
	CurrentVal =:= 1,
	(I =:= 1;
	 J =:= 1;
	(NewI is I-1, NewJ is J-1, slot(Id,coordinate(NewI,NewJ),NewCurrentVal),is_stable_north_west(coordinate(NewI,NewJ),Id,NewCurrentVal))).

is_stable_south_east(coordinate(I,J),Id,CurrentVal):-
	CurrentVal =:= 1,
	dimension(N),
	(I =:= N;
	 J =:= N;
	(I < N, J < N,!, NewI is I+1, NewJ is J+1,
	 slot(Id,coordinate(NewI,NewJ),NewCurrentVal),is_stable_south_east(coordinate(NewI,NewJ),Id,NewCurrentVal))).

is_stable_north_east(coordinate(I,J),Id,CurrentVal):-
	CurrentVal =:= 1,
	dimension(N),
	(I =:= 1;
	 J =:= N;
	(NewI is I-1, NewJ is J+1, slot(Id,coordinate(NewI,NewJ),NewCurrentVal),is_stable_north_east(coordinate(NewI,NewJ),Id,NewCurrentVal))).

is_stable_south_west(coordinate(I,J),Id,CurrentVal):-
	CurrentVal =:= 1,
	dimension(N),
	(I =:= N;
	 J =:= 1;
	(NewI is I+1, NewJ is J-1, slot(Id,coordinate(NewI,NewJ),NewCurrentVal),is_stable_south_west(coordinate(NewI,NewJ),Id,NewCurrentVal))).

full_row(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal),(CurrentVal =:= 1; CurrentVal =:= 2),
	(J < N,!,NewJ is J+1,full_row(coordinate(I,NewJ),Id)).

full_column(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal),(CurrentVal =:= 1; CurrentVal =:= 2),
	(I < N,!,NewI is I+1,full_column(coordinate(NewI,J),Id)).

full_diagonal_north_west(coordinate(I,J),Id):-
	slot(Id,coordinate(I,J),CurrentVal), (CurrentVal =:= 1; CurrentVal =:= 2),
	(I > 1, J > 1,!,NewI is I-1, NewJ is J-1,full_diagonal_north_west(coordinate(NewI,NewJ),Id)).

full_diagonal_south_east(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal), (CurrentVal =:= 1; CurrentVal =:= 2),
	(I < N, J < N,!,NewI is I+1, NewJ is J+1,full_diagonal_south_east(coordinate(NewI,NewJ),Id)).

full_diagonal_north_east(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal), (CurrentVal =:= 1; CurrentVal =:= 2),
	(I > 1, J < N,!,NewI is I-1, NewJ is J+1,full_diagonal_north_east(coordinate(NewI,NewJ),Id)).

full_diagonal_south_west(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal), (CurrentVal =:= 1; CurrentVal =:= 2),
	(I < N, J > 1,!,NewI is I+1, NewJ is J-1,full_diagonal_south_west(coordinate(NewI,NewJ),Id)).

own_rows_up(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal),
	CurrentVal =:= 1,
	 ((I =:= 1, J=:= N);
	 (J < N, NewJ is J+1, own_rows_up(I, NewJ));
	 (I > 1, NewI is I-1, own_rows_up(NewI,1))).

own_rows_down(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal),
	CurrentVal =:= 1,
	 ((I =:= N, J =:= N);
	 (J < N, NewJ is J+1, own_rows_down(I, NewJ));
	 (I < N, NewI is I+1, own_rows_down(NewI,1))).

own_columns_left(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal),
	CurrentVal =:= 1,
	 ((I =:= N, J =:= 1);
	 (I < N, NewI is I+1, own_columns_left(NewI, J));
	 (J > 1, NewJ is J-1, own_columns_left(1,NewJ))).

own_columns_right(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal),
	CurrentVal =:= 1,
	((I =:= N, J =:= N);
	 (I < N, NewI is I+1, own_columns_right(NewI, J));
	 (J < N, NewJ is J+1, own_columns_right(1,NewJ))).

own_diagonals_south_west(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal),
	CurrentVal =:= 1,
	is_stable_north_west(coordinate(I,J),Id,CurrentVal),is_stable_south_east(coordinate(I,J),Id,CurrentVal),
	((I =:= N, J =:= 1);
	(J > 1, NewJ is J-1,own_diagonals_south_west(coordinate(I,NewJ),Id));
	(I < N, NewI is I+1,own_diagonals_south_west(coordinate(NewI,J),Id))).

own_diagonals_north_east(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal),
	CurrentVal =:= 1,
	is_stable_north_west(coordinate(I,J),Id,CurrentVal),is_stable_south_east(coordinate(I,J),Id,CurrentVal),
	((I =:= 1, J =:= N);
	(J < N, NewJ is J+1,own_diagonals_north_east(coordinate(I,NewJ),Id));
	(I > 1, NewI is I-1,own_diagonals_north_east(coordinate(NewI,J),Id))).

own_diagonals_south_east(coordinate(I,J),Id):-
	dimension(N),
	slot(Id,coordinate(I,J),CurrentVal),
	CurrentVal =:= 1,
	is_stable_north_east(coordinate(I,J),Id,CurrentVal),is_stable_south_west(coordinate(I,J),Id,CurrentVal),
	((I =:= N, J =:= N);
	(J < N, NewJ is J+1,own_diagonals_south_east(coordinate(I,NewJ),Id));
	(I < N, NewI is I+1,own_diagonals_south_east(coordinate(NewI,J),Id))).

own_diagonals_north_west(coordinate(I,J),Id):-
	slot(Id,coordinate(I,J),CurrentVal),
	CurrentVal =:= 1,
	is_stable_north_east(coordinate(I,J),Id,CurrentVal),is_stable_south_west(coordinate(I,J),Id,CurrentVal),
	((I =:= 1, J =:= 1);
	(J > 1, NewJ is J-1,own_diagonals_north_west(coordinate(I,NewJ),Id));
	(I > 1, NewI is I-1,own_diagonals_north_west(coordinate(NewI,J),Id))).
