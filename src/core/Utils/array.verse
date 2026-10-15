(Array:[]int).InsertSorted<public>(Value:int)<computes>:[]int=
    After:[]int = for (Existing : Array, Existing >= Value) do Existing
    Before:[]int = for (Existing : Array, Existing < Value) do Existing
    Before + array{Value} + After