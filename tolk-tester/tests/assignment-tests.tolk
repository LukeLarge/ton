fun extractFromTypedTuple(params: [int]) {
    var [payload: int] = params;
    return payload + 10;
}

@method_id(101)
fun test101(x: int) {
    var params = [x];
    return extractFromTypedTuple(params);
}

fun autoInferIntNull(x: int) {
    if (x > 10) { return null; }
    return x;
}

fun typesAsIdentifiers(builder: builder) {
    var int = 1;
    var cell = builder.endCell();
    var slice = cell.beginParse();
    {
        var cell: cell = cell;
        var tuple: tuple = createEmptyTuple();
        var bool: bool = tuple.tupleAt<int>(0) > 0;
    }
    return int;
}

global callOrder: tuple;

fun getTensor_12() {
    callOrder.tuplePush(100);
    return (1, 2);
}
fun getTensor_1X(x: int) {
    callOrder.tuplePush(101);
    return (1, x);
}
fun getTuple_12() {
    callOrder.tuplePush(110);
    return [1, 2];
}
fun getTuple_1X(x: int) {
    callOrder.tuplePush(111);
    return [1, x];
}
fun getUntypedTuple_12() {
    callOrder.tuplePush(120);
    var t = createEmptyTuple(); t.tuplePush(1); t.tuplePush(2);
    return t;
}
fun getUntypedTuple_1X(x: int) {
    callOrder.tuplePush(121);
    var t = createEmptyTuple(); t.tuplePush(1); t.tuplePush(x);
    return t;
}
fun getIntValue5() {
    callOrder.tuplePush(10);
    return 5;
}
fun getIntValueX(x: int) {
    callOrder.tuplePush(11);
    return x;
}

@method_id(102)
fun test102() {
    callOrder = createEmptyTuple();
    var x = 0;
    getTensor_12().0 = getIntValue5();
    getTensor_1X(5).1 = getIntValue5();
    getTensor_1X(x = 10).0 = getIntValueX(x);
    return (callOrder, x);
}

@method_id(103)
fun test103() {
    callOrder = createEmptyTuple();
    var x = 0;
    getTuple_12().0 = getIntValue5();
    getTuple_1X(5).1 = getIntValue5();
    getTuple_1X(x = 10).0 = getIntValueX(x);
    return (callOrder, x);
}

@method_id(104)
fun test104() {
    callOrder = createEmptyTuple();
    var x = 0;
    getUntypedTuple_12().0 = getIntValue5();
    getUntypedTuple_1X(5).1 = getIntValue5();
    getUntypedTuple_1X(x = 10).0 = getIntValueX(x);
    return (callOrder, x);
}

@method_id(105)
fun test105() {
    callOrder = createEmptyTuple();
    getTensor_12().0 = getTensor_1X(getIntValue5()).1 = getIntValueX(getTensor_12().1);
    return callOrder;
}

@method_id(106)
fun test106() {
    callOrder = createEmptyTuple();
    getTuple_12().0 = getTuple_1X(getIntValue5()).1 = getIntValueX(getTuple_12().1);
    return callOrder;
}

global t107: (int, int);

@method_id(107)
fun test107() {
    ((t107 = (1, 2)).0, (t107 = (3, 4)).1) = (5, 6);
    return t107;
}

global g108: int;
fun assertEq(a: int, b: int) {
    assert(a == b, 10);
    return b;
}

@method_id(108)
fun test108() {
    callOrder = createEmptyTuple();
    g108 = 0;
    getTensor_1X(g108 = 8).1 = assertEq(g108, 8);
    return (callOrder, g108);
}

@method_id(109)
fun test109() {
    callOrder = createEmptyTuple();
    var x = 0;
    [getTuple_12().0, getTuple_1X(x = getIntValue5()).1, getTuple_1X(x += 10).0] = [getIntValue5(), getIntValue5(), getIntValueX(x)];
    return (callOrder, x);
}

global g110: int;
global t110: (int, int);

@method_id(110)
fun test110() {
    callOrder = createEmptyTuple();
    var xy = [0, 0];
    [xy.0, getTuple_1X(g110 = 8).0] = [g110 += 5, getIntValueX(g110 += 10)];
    [xy.1, getTuple_1X((t110 = (8, 9)).0).1] = [t110.0 += 5, getIntValueX(t110.1 += 10)];
    return (xy, callOrder, g110, t110);
}

@method_id(111)
fun test111() {
    callOrder = createEmptyTuple();
    var z = -1;
    var xy = [0, z = 0];
    var rhs = [getIntValueX(xy.1 += 10), xy.1, xy.0, z += 50];
    [xy.0, getTuple_1X(g110 = 8 + getIntValueX(xy.1)).0, xy.1, z] = rhs;
    return (xy, g110, callOrder, z);
}

@method_id(112)
fun test112() {
    var xy = [1, 2];
    ((((xy))).0, ((xy.1))) = ((xy).1, ((xy.0)));
    return xy;
}

@method_id(113)
fun test113() {
    var (a, t, z) = (1, [2,3], (-1,-1));
    (a, t, a, z, t.1, z.1) = (10, [a,12], 13, (a, t.1), 14, t.1);
    return (a, t, z);
}

global g114: int;
global t114: [int, int];
global z114: (int, int);

@method_id(114)
fun test114() {
    g114 = 1;
    t114 = [2, 3];
    (g114, t114, g114, z114, t114.1, z114.1) = (10, [g114,12], 13, (g114, t114.1), 14, t114.1);
    return (g114, t114, z114);
}

@method_id(115)
fun test115() {
    callOrder = createEmptyTuple();
    var x = 0;
    var y = 0;
    [getTensor_1X(x = 5).0, y] = getTuple_1X(x = 9);
    return (callOrder, x, y);
}

@method_id(116)
fun test116() {
    var (a,b,c,d) = (0,0,0,0);
    var rhs = [1, 2, 3, 4];
    var rhs2 = ([a,b,c,d] = rhs);
    __expect_type(rhs2, "[int, int, int, int]");
    return (a, b, c, d, rhs2);
}



fun main(value: int) {
    var (x: int?, y) = (autoInferIntNull(value), autoInferIntNull(value * 2));
    if (x == null && y == null) { return null; }
    return x == null || y == null ? -1 : x! + y!;
}

/**
@testcase | 0   | 3      | 9
@testcase | 0   | 6      | -1
@testcase | 0   | 11     | (null)
@testcase | 101 | 78     | 88
@testcase | 102 |        | [ 100 10 101 10 101 11 ] 10
@testcase | 103 |        | [ 110 10 111 10 111 11 ] 10
@testcase | 104 |        | [ 120 10 121 10 121 11 ] 10
@testcase | 105 |        | [ 100 10 101 100 11 ]
@testcase | 106 |        | [ 110 10 111 110 11 ]
@testcase | 107 |        | 3 4
@testcase | 108 |        | [ 101 ] 8
@testcase | 109 |        | [ 110 10 111 111 10 10 11 ] 15
@testcase | 110 |        | [ 13 13 ] [ 111 11 111 11 ] 23 13 19
@testcase | 111 |        | [ 10 0 ] 18 [ 11 11 111 ] 50
@testcase | 112 |        | [ 2 1 ]
@testcase | 113 |        | 13 [ 1 14 ] 1 3
@testcase | 114 |        | 13 [ 1 14 ] 1 3
@testcase | 115 |        | [ 101 111 ] 9 9
@testcase | 116 |        | 1 2 3 4 [ 1 2 3 4 ]


@fif_codegen
"""
  test116 PROC:<{
    //
    1 PUSHINT	//  '10=1
    2 PUSHINT	//  '10=1 '11=2
    3 PUSHINT	//  '10=1 '11=2 '12=3
    4 PUSHINT	//  '10=1 '11=2 '12=3 '13=4
    4 TUPLE	//  rhs
    DUP	//  rhs rhs
    4 UNTUPLE	//  rhs2 a b c d
    4 ROLL	//  a b c d rhs2
  }>
"""
*/
