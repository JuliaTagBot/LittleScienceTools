@test interwine([1,2], [3,4]) == [1,3,2,4]
@test interwine([1 2; 3 4], [5 6; 7 8]) == [1 5 2 6; 3 7 4 8]
